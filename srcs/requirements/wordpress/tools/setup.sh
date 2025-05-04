#!/bin/bash

# Wait for MariaDB to be ready
while ! mariadb -h mariadb -P 3306 -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" ${MYSQL_DATABASE} >/dev/null 2>&1; do
    echo "Waiting for MariaDB to be ready..."
    sleep 5
done

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found, downloading..."
    
    # Download WordPress core
    wp core download --allow-root
    
    # Create wp-config.php
    wp config create --dbname=${MYSQL_DATABASE} \
                    --dbuser=${MYSQL_USER} \
                    --dbpass=${MYSQL_PASSWORD} \
                    --dbhost=mariadb \
                    --allow-root
    
    # Install WordPress
    wp core install --url=${DOMAIN_NAME} \
                   --title="Inception WordPress" \
                   --admin_user=${WP_ADMIN_USER} \
                   --admin_password=${WP_ADMIN_PASSWORD} \
                   --admin_email=${WP_ADMIN_EMAIL} \
                   --allow-root
    
    # Create an additional user
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
                  --user_pass=${WP_USER_PASSWORD} \
                  --role=author \
                  --allow-root
    
    echo "WordPress installed successfully!"
else
    echo "WordPress already installed, skipping setup."
fi

# Ensure correct ownership of files
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
exec "$@"