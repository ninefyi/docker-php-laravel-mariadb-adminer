FROM php:7.2.5-apache

ENV ACCEPT_EULA=Y

# Update gnupg
RUN apt-get update && apt-get install -my wget gnupg

RUN apt-get install -y libpng-dev libzip-dev zip

RUN docker-php-ext-configure zip --with-libzip

RUN apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN docker-php-ext-install zip gd mbstring pdo pdo_mysql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug gd zip

ADD www /var/www/html
ADD apache-config.conf /etc/apache2/sites-available/000-default.conf
ADD apache2.conf /etc/apache2/apache2.conf
# COPY index.php /var/www/html

RUN a2enmod rewrite

# INSTALL Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs

COPY src /var/www/html

# RUN chmod +x /var/www/html/src/startup.sh

#RUN chmod +x /var/www/html/src/compile.sh

# ENTRYPOINT ["/var/www/html/src/startup.sh"]
