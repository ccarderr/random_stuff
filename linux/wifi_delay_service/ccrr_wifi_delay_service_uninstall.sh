#!/bin/bash

# Stop the service if it's running
sudo systemctl stop ccrr_wifi_delay.service

# Disable the service so it doesn't start on boot
sudo systemctl disable ccrr_wifi_delay.service

# Remove the service unit file
sudo rm /etc/systemd/system/ccrr_wifi_delay.service

# Reload systemd to reflect the changes
sudo systemctl daemon-reload

# Confirm that the service has been removed
echo "ccrr_wifi_delay service has been removed."
