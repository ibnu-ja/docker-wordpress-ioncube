# Docker WordPress Ioncube

This project provides a Dockerized environment for running WordPress with Ioncube support. It uses Docker/Podman to manage containers and includes configuration for running PHP with Ioncube Loader.

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

### 5. Bring down the containers

If you need to stop the containers, you can bring them down with:
```bash
docker compose down
```

or
```bash
podman compose down
```

### 6. Set the correct file permissions

Make sure that the `uploads`, `plugins`, and `themes` directories have the correct ownership for the web server to access:

```bash
sudo chown -R user:user ./uploads ./plugins ./themes
```

Replace `user:user` with the appropriate user and group for your environment.

### 7. Restart the containers

After adjusting file permissions, you can bring the containers back up:
```bash
docker compose up -d
```

or
```bash
podman compose up -d
```