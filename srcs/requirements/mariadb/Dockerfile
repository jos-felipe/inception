FROM debian:oldstable

RUN apt-get update && apt-get install -y \
	mariadb-server \
	&& chown -R mysql:mysql /var/lib/mysql \
	&& mkdir -p /run/mysqld \
	&& chown -R mysql:mysql /run/mysqld \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/
COPY ./tools/setup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT [ "setup.sh" ]

USER mysql

CMD [ "mysql" ]