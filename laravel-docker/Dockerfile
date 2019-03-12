FROM php:7.1-fpm

# atualização e dependencias.
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mysql-client \
    libpq-dev \
    unzip \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \ 
    libicu-dev \
    libpng-dev \
    libbz2-dev \
    cron \
    && pecl channel-update pecl.php.net \
    && pecl install apcu

# PHP Extensions
# RUN docker-php-ext-install mcrypt zip bz2 mbstring pdo pdo_msyql mysqli pcntl \
RUN docker-php-ext-configure intl \
&& docker-php-ext-install intl zip pdo_mysql \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd

# Configurações de memória PHP
RUN echo "memory_limit=1024M" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "max_execution_time=900" >> $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/apcu.ini
RUN echo "post_max_size=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "upload_max_filesize=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Mostrando erros no stderr
RUN echo "display_errors=stderr" > $PHP_INI_DIR/conf.d/display-errors.ini

# Removendo pathinfo
RUN echo "cgi.fix_pathinfo=0" > $PHP_INI_DIR/conf.d/path-info.ini

# Removendo expose PHP
RUN echo "expose_php=0" > $PHP_INI_DIR/conf.d/path-info.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD . /var/www/html
WORKDIR /var/www/html

RUN touch storage/logs/laravel.log

RUN composer update && composer install
# RUN php artisan optimize --force
# RUN php artisan route:cache

RUN chmod -R 777 /var/www/html/storage

RUN touch /var/log/cron.log

ADD deploy/cron/artisan-schedule-run /etc/cron.d/artisan-schedule-run
RUN chmod 0644 /etc/cron.d/artisan-schedule-run
RUN chmod +x /etc/cron.d/artisan-schedule-run
RUN touch /var/log/cron.log

CMD ["/bin/sh", "-c", "php-fpm -D | tail -f storage/logs/laravel.log"]