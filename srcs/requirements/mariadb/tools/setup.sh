#!/bin/bash

# Check if database directory is initialized
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # Initialize MySQL data directory if needed
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "Initializing MySQL data directory..."
        mysql_install_db --user=mysql --datadir=/var/lib/mysql
    fi

    # Start MariaDB server
    echo "Starting MariaDB server for initialization..."
    mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait for server to start
    until mysqladmin ping >/dev/null 2>&1; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done
    
    # Create database and users
    echo "Creating database and users..."
    mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    mysql -e "FLUSH PRIVILEGES;"
    
    # Shutdown server to restart cleanly
    echo "Initialization complete. Restarting MariaDB..."
    mysqladmin shutdown
    
    echo "MariaDB database and users created."
else
    echo "Database already exists, skipping initialization."
fi

# Start MariaDB server in foreground
echo "Starting MariaDB server..."
exec mysqld --user=mysql