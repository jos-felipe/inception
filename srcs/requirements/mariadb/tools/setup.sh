#!/bin/bash

# Start MariaDB service for initialization
service mariadb start

# Wait for the MariaDB service to start
sleep 5

# For debug purposes
echo "MySQL environment variables:"
echo "MYSQL_DATABASE: $MYSQL_DATABASE"
echo "MYSQL_USER: $MYSQL_USER"
echo "MYSQL_ROOT_PASSWORD length: ${#MYSQL_ROOT_PASSWORD}"

# Check if database exists already
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # Create database and users
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    
    echo "MariaDB database and users created."
else
    echo "Database already exists, skipping initialization."
    # When accessing an existing setup, we need to use the password
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES;"
fi

# Stop MariaDB service to restart properly with Docker
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Start MariaDB with proper command for Docker
exec "$@"