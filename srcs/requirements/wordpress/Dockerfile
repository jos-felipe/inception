FROM debian:oldstable

RUN apt-get update && apt-get install -y \
	php7.3-fpm \
	php7.3-mysql \
	php7.3-curl \
	php7.3-gd \
	php7.3-intl \
	php7.3-mbstring \
	php7.3-soap \
	php7.3-xml \
	php7.3-xmlrpc \
	php7.3-zip \
	curl \
	mariadb-client \
	&& apt-get clean \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php && \
	sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/' /etc/php/7.3/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

CMD ["php-fpm7.3", "-F"]