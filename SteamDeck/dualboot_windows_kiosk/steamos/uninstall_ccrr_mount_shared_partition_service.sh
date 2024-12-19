#!/bin/bash

# Name of the systemd service
SERVICE_NAME="ccrr_mount_shared_partition.service"

# Stop and disable the service
echo "Stopping the service..."
sudo systemctl stop $SERVICE_NAME

echo "Disabling the service..."
sudo systemctl disable $SERVICE_NAME

# Remove the service file
echo "Removing the service file..."
sudo rm -f /etc/systemd/system/$SERVICE_NAME

# Reload systemd to apply changes
echo "Reloading systemd to apply changes..."
sudo systemctl daemon-reload

echo "Service '$SERVICE_NAME' has been successfully uninstalled."
