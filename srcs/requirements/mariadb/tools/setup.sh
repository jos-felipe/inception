#!/bin/bash

# Start MariaDB service for initialization
service mariadb start

# Wait until the server is ready
until mariadb -u root -e "SELECT 1;" &> /dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done

# Check if database exists already
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # Create database and users
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    mysql -e "FLUSH PRIVILEGES;"
    
    echo "MariaDB database and users created."
else
    echo "Database already exists, skipping initialization."
fi