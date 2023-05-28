FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update
RUN apt-get install -y php8.1
RUN apt-get install -y php8.1-fpm
RUN apt-get install -y php8.1-pgsql
RUN apt-get install -y php8.1-mbstring
RUN apt-get install -y unzip
RUN apt-get install -y git
RUN apt-get install -y php8.1-curl
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libxml2
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libzip-dev
RUN apt-get install -y php8.1-gd
RUN apt-get install -y --no-install-recommends libssl-dev
RUN apt-get install -y php-pear
RUN apt-get install -y php8.1-zip
RUN apt-get install -y php-dev
RUN pecl install swoole


WORKDIR /var/www/html

RUN apt-get install -y nodejs

RUN apt-get install -y npm

RUN npm install --save-dev chokidar

WORKDIR /var/www/html/marhaba-api
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1


ARG MOUNT_PATH

CMD bash -c "echo 'extension=swoole' >> $(php -i | grep /.+/php.ini -oE)" ;\
    composer install ;\
    echo 1| php artisan octane:install ;\
    php artisan key:generate ;\
    php artisan migrate ;\
    php artisan db:seed ;\
    php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000 --workers=auto --task-workers=auto --max-requests=500 --watch
