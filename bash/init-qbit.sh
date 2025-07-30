#!/bin/bash

echo "Waiting for qBittorrent to start..."
until curl -s http://localhost:8080/api/v2/app/version > /dev/null 2>&1; do
    sleep 2
done

echo "qBittorrent is running, checking for temporary password..."
TEMP_PASS=$(docker logs qbittorrent 2>&1 | grep -o "temporary password.*: [A-Za-z0-9]*" | tail -1 | cut -d' ' -f4)

if [ -n "$TEMP_PASS" ]; then
    echo "Found temporary password: $TEMP_PASS"
    echo "Setting permanent password..."
    
    # Login with temporary password and set permanent password
    curl -c cookies.txt -X POST \
        -d "username=admin&password=$TEMP_PASS" \
        http://localhost:8080/api/v2/auth/login
    
    # Set permanent password
    curl -b cookies.txt -X POST \
        -d "json={\"web_ui_password\":\"qbitDefaultPass123!\"}" \
        http://localhost:8080/api/v2/app/setPreferences
    
    # Configure download paths
    curl -b cookies.txt -X POST \
        -d "json={\"save_path\":\"/data/torrents/complete\",\"temp_path\":\"/data/torrents/incomplete\",\"temp_path_enabled\":true,\"torrent_export_dir\":\"/data/torrents/torrent-files\",\"scan_dirs\":{\"/data/torrents/watch\":1}}" \
        http://localhost:8080/api/v2/app/setPreferences
    
    rm -f cookies.txt
    echo "qBittorrent configured with admin/qbitDefaultPass123!"
else
    echo "No temporary password found, qBittorrent may already be configured"
fi