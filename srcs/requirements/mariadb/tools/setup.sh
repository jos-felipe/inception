#!/bin/bash

# Start MariaDB service for initialization
service mariadb start

# Wait for the MariaDB service to start
sleep 5

# Check if database exists already
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # Create database and users
    mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    mysql -e "FLUSH PRIVILEGES;"
    
    echo "MariaDB database and users created."
else
    echo "Database already exists, skipping initialization."
fi

# Stop MariaDB service to restart properly with Docker
service mariadb stop

# Start MariaDB with proper command for Docker
exec "$@"