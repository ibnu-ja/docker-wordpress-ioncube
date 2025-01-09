ARG PHP_VER=8.3

FROM wordpress:php${PHP_VER}-fpm-alpine

ARG PHP_VER

# Validate PHP_VERSION within range
RUN /bin/bash -c 'if [[ ! "$PHP_VER" =~ ^7\.[4-9]$|^8\.[0-3]$ ]]; then \
        echo "Error: PHP version $PHP_VER does not match between 7.4 and 8.3"; \
        exit 1; \
    fi'

# Set up PHP configuration, change if needed
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Strip out the patch version (e.g., 8.1.31 -> 8.1)
RUN echo "Using PHP version: $PHP_VER" && \
    mkdir -p /opt/ioncube && \
    curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz | \
    tar -xz -C /opt/ioncube --strip-components=1 && \
    echo "zend_extension = /opt/ioncube/ioncube_loader_lin_${MAJOR_MINOR_VERSION}.so" >> $PHP_INI_DIR/php.ini

# Copy the modified entrypoint script to the container
COPY docker-entrypoint.sh /usr/local/bin/

# Set the correct permissions for the entrypoint script
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
