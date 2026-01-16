#!/bin/bash

# Fleetbase VPS Deployment Script (Hostinger/Ubuntu)

# 1. Update & Install Docker if missing
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Installing..."
    apt-get update
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# 2. Pull latest code (if inside a git repo)
if [ -d ".git" ]; then
    echo "Pulling latest changes..."
    git pull origin main
fi

# 3. Create necessary volumes/networks implies by up, but ensure permissions if needed
# (Docker handles this usually)

# 4. Start Services
echo "Starting Fleetbase with Caddy..."
docker compose up -d --build --remove-orphans

echo "Deployment complete!"
echo "Visit https://admin.skedadel.co"
