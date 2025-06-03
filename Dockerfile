FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd \
    pdo_mysql \
    zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory /var/www/html

RUN a2enmod rewrite headers expires deflate

COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN curl -sS https://getcomposer.org/installer  | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html
RUN composer install --no-dev --no-interaction --optimize-autoloader

RUN php artisan key:generate

EXPOSE 80