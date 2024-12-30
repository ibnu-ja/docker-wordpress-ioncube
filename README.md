# Rootless Docker WordPress Ioncube

This project provides a rootless Dockerized environment for running WordPress with Ioncube support. It uses Docker/Podman to manage containers and includes configuration for running PHP with Ioncube Loader.

If you want to use in rootfull environment, take a look at `Dockerfile` and just copy the ioncube parts.

## Setup Instructions

### 1. Clone the repository
Clone this repository to your local machine:
```bash
git clone git@github.com:ibnu-ja/docker-wordpress-ioncube.git
cd docker-wordpress-ioncube
```

### 2. Copy the environment configuration file
```bash
cp .env.example .env
```

### 3. Edit `docker-compose.yaml`

Open `docker-compose.yaml` and make the necessary adjustments:

- Your WordPress & Adminer port
- Set the appropriate `PHP_VERSION` context to the version of PHP you want to use.

### 4. Start the containers

Use `docker-compose` (or `podman compose` if you're using Podman) to start the containers:
```bash
docker compose up -d
```
or
```bash
podman compose up -d
```

