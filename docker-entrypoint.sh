#!/usr/bin/env bash
set -Eeuo pipefail

# Force root for all actions
user="root"
group="root"

# If WordPress is not installed, copy it from the official source
if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
    echo >&2 "WordPress not found in $PWD - copying now..."
    # If the directory is empty, proceed to copy WordPress
    if [ -n "$(find -mindepth 1 -maxdepth 1 -not -name wp-content)" ]; then
        echo >&2 "WARNING: $PWD is not empty! (copying anyhow)"
    fi

    # Set tar arguments for copying WordPress files
    sourceTarArgs=(
        --create
        --file -
        --directory /usr/src/wordpress
        --owner "$user" --group "$group"
    )
    targetTarArgs=(
        --extract
        --file -
    )

    # Avoid file system permission issues with tar if not root
    if [ "$(id -u)" != '0' ]; then
        targetTarArgs+=( --no-overwrite-dir )
    fi

    # Copy WordPress from the source to the current directory
    tar "${sourceTarArgs[@]}" . | tar "${targetTarArgs[@]}"
    echo >&2 "WordPress has been successfully copied to $PWD"
fi

# Check if wp-config.php exists and create it if necessary using environment variables
wpEnvs=( "${!WORDPRESS_@}" )
if [ ! -s wp-config.php ] && [ "${#wpEnvs[@]}" -gt 0 ]; then
    for wpConfigDocker in wp-config-docker.php /usr/src/wordpress/wp-config-docker.php; do
        if [ -s "$wpConfigDocker" ]; then
            echo >&2 "No 'wp-config.php' found, but 'WORDPRESS_...' variables supplied; creating wp-config.php"

            # Replace placeholder with unique string
            awk '
                /put your unique phrase here/ {
                    cmd = "head -c1m /dev/urandom | sha1sum | cut -d\\  -f1"
                    cmd | getline str
                    close(cmd)
                    gsub("put your unique phrase here", str)
                }
                { print }
            ' "$wpConfigDocker" > wp-config.php

            # Ensure wp-config.php is owned by root
            chown "$user:$group" wp-config.php || true
            break
        fi
    done
fi

exec "$@"
