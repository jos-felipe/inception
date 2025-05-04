NAME = inception
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	mkdir -p /home/$(USER)/data/wordpress
	mkdir -p /home/$(USER)/data/mariadb
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build

down:
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

clean: down
	docker system prune -a

fclean:
	rm -rf /home/$(USER)/data

re: fclean all

.PHONY: all up down clean fclean re