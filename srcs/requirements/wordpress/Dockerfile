FROM debian:oldstable

RUN apt-get update && apt-get install -y \
	php7.4-fpm \
	php7.4-mysql \
	php7.4-curl \
	php7.4-gd \
	php7.4-intl \
	php7.4-mbstring \
	php7.4-soap \
	php7.4-xml \
	php7.4-xmlrpc \
	php7.4-zip \
	curl \
	mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php && \
	sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["php-fpm7.4", "-F"]