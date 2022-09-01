FROM oraclelinux:8

RUN    dnf -y install oraclelinux-developer-release-el8 oracle-instantclient-release-el8 
RUN    dnf -y module enable php:7.4 php-oci8 
RUN    dnf -y install  php-oci8-21c \
    php-cli \
    php-common \
    php-fpm \
    php-mbstring \
    php-pdo \
    php-bcmath \
    php-intl \
    php-gd \
    php-pdo \
    php-zip \
    php-opcache && \
    rm -rf /var/cache/dnf \
    && \
    # Enable external access to PHP-FPM
    mkdir -p /run/php-fpm \
    && \
    sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php-fpm.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf \
    && \
    # Redirect worker output to stdout for container logging
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf 
RUN sed -i '/;date.timezone =/ c\date.timezone = "Asia/Bangkok"' /etc/php.ini 
RUN sed -i '/memory_limit = 128M/ c\memory_limit = 1024M' /etc/php.ini 
RUN sed -i '/;default_charset =/ c\default_charset = "utf-8' /etc/php.ini 
RUN sed -i '/max_execution_time = 30/ c\max_execution_time = 1200' /etc/php.ini 
RUN sed -i '/max_input_time = 60/ c\max_input_time = 300' /etc/php.ini 
RUN sed -i '/upload_max_filesize = 2M/ c\upload_max_filesize = 512M' /etc/php.ini 
RUN sed -i '/post_max_size = 8M/ c\post_max_size = 512M' /etc/php.ini  

EXPOSE 9000

WORKDIR /var/www

CMD ["/sbin/php-fpm", "-F", "-O"]

