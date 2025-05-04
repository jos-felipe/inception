FROM debian:oldstable

RUN apt-get update && apt-get install -y \
	mariadb-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/
COPY ./tools/setup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT [ "setup.sh" ]

CMD [ "mysql" ]