ARG PHP_VERSION=8.1

FROM wordpress:php${PHP_VERSION}-apache

# Validate PHP_VERSION within range
RUN /bin/bash -c 'if [[ ! "$PHP_VERSION" =~ ^(7\.[4-9]\.[0-9]+|8\.[0-3]\.[0-9]+)$ ]]; then \
        echo "Error: PHP version $PHP_VERSION not match between 7.4 and 8.3"; \
        exit 1; \
    fi'

# Set environment variables for UID and GID
ENV UID=1000
ENV GID=1000

# Set up PHP configuration, change if needed
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Strip out the patch version (e.g., 8.1.31 -> 8.1)
RUN MAJOR_MINOR_VERSION=$(echo "$PHP_VERSION" | sed 's/\([0-9]\+\.[0-9]\+\)\..*/\1/') && \
    echo "Using PHP version: $MAJOR_MINOR_VERSION" && \
    mkdir -p /opt/ioncube && \
    curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz | \
    tar -xz -C /opt/ioncube --strip-components=1 && \
    echo "zend_extension = /opt/ioncube/ioncube_loader_lin_${MAJOR_MINOR_VERSION}.so" >> $PHP_INI_DIR/php.ini
