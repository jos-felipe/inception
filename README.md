# Inception

## Overview
Inception is a system administration project focused on using Docker to create a small infrastructure composed of different services. The project involves setting up a multi-container environment with NGINX, WordPress (with php-fpm), and MariaDB, all running in separate containers and communicating with each other via a Docker network.

## Project Structure
```
.
├── Makefile
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── nginx
        │   ├── Dockerfile
        │   ├── conf
        │   │   └── nginx.conf
        │   └── tools
        ├── wordpress
        │   ├── Dockerfile
        │   ├── conf
        │   └── tools
        │       └── setup.sh
        └── mariadb
            ├── Dockerfile
            ├── conf
            │   └── 50-server.cnf
            └── tools
                └── setup.sh
```

## Features
- **NGINX Container**: Serves as the entry point with TLSv1.2/TLSv1.3 support
- **WordPress Container**: Runs WordPress with php-fpm
- **MariaDB Container**: Database server for WordPress
- **Persistent Volumes**: For WordPress files and database data
- **Docker Network**: Custom network for inter-container communication
- **Automatic Restart**: Containers restart automatically in case of crash
- **Environment Variables**: No passwords are hardcoded in Dockerfiles
- **Custom Domain**: Configuration for custom domain (yourlogin.42.fr)

## Prerequisites
- Docker and Docker Compose
- Make
- Virtual Machine (as required by the project)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/jos-felipe/inception.git
   cd inception
   ```

2. Configure your local domain:
   Add the following line to your `/etc/hosts` file:
   ```
   127.0.0.1 josfelip.42.fr
   ```
   Note: Replace "josfelip" with your login.

3. Build and start the containers:
   ```bash
   make
   ```

This will:
- Create necessary directories for volumes
- Build Docker images for all services
- Start the containers in detached mode

## Usage

Once the services are running, you can access WordPress at:
```
https://josfelip.42.fr
```

Note: Since the SSL certificate is self-signed, you'll need to accept the security warning in your browser.

## Commands

The Makefile provides several useful commands:

- `make`: Build and start all containers
- `make up`: Same as above
- `make down`: Stop and remove containers
- `make clean`: Stop containers and clean Docker resources
- `make fclean`: Perform clean and remove all persistent data
- `make re`: Rebuild the entire environment from scratch

## Container Details

### NGINX
- Based on Debian
- Configured with TLSv1.2/TLSv1.3 only
- Self-signed SSL certificate
- Acts as a reverse proxy for WordPress

### WordPress
- Based on Debian
- PHP-FPM 7.4 configured for WordPress
- WP-CLI for WordPress setup and management
- Creates administrator and regular user accounts

### MariaDB
- Based on Debian
- Configured to allow connections from WordPress
- Initializes database and users on first run

## Volumes

Two persistent volumes are mounted:
- WordPress files: `/home/josfelip/data/wordpress`
- MariaDB data: `/home/josfelip/data/mariadb`

## Networking

All containers communicate through a custom bridge network named `inception_network`. The NGINX container is the only one exposing a port (443) to the host machine.

## Troubleshooting

If you encounter issues:

1. Check container status:
   ```bash
   docker ps
   ```

2. View container logs:
   ```bash
   docker logs nginx
   docker logs wordpress
   docker logs mariadb
   ```

3. Ensure volumes are properly mounted:
   ```bash
   docker volume ls
   ```

4. Verify network configuration:
   ```bash
   docker network inspect inception_network
   ```

## License
This project is part of the 42 School curriculum.
