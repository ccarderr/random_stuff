#!/bin/bash

# Creating the systemd service unit file
echo "[Unit]
Description=Toggle WiFi Off and On after 30 seconds
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c \"nmcli radio wifi off && sleep 30 && nmcli radio wifi on\"

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/ccrr_wifi_delay.service > /dev/null

# Reload systemd unit files
sudo systemctl daemon-reload

# Enable the service to start automatically on boot
sudo systemctl enable ccrr_wifi_delay.service

# Start the service immediately
sudo systemctl start ccrr_wifi_delay.service

echo "ccrr_wifi_delay service has been installed and started."
