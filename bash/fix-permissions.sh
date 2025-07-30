#!/bin/bash

# Fix permissions for Jellyfin and other media server containers
echo "Fixing permissions for media server containers..."

# Fix Jellyfin permissions
echo "Setting ownership for Jellyfin config and cache..."
sudo chown -R 1000:1000 ./jellyfn/config
sudo chown -R 1000:1000 ./jellyfn/cache
sudo chmod -R 755 ./jellyfn/config
sudo chmod -R 755 ./jellyfn/cache

# Fix other container permissions
echo "Setting ownership for other containers..."
sudo chown -R 1000:1000 ./radarr/config
sudo chown -R 1000:1000 ./sonarr
sudo chown -R 1000:1000 ./qbit
sudo chown -R 1000:1000 ./prowlarr
sudo chown -R 1000:1000 ./data

echo "Setting permissions..."
sudo chmod -R 755 ./radarr/config
sudo chmod -R 755 ./sonarr
sudo chmod -R 755 ./qbit
sudo chmod -R 755 ./prowlarr
sudo chmod -R 755 ./data

echo "Restarting containers..."
docker compose restart

echo "Permissions fixed successfully!"
