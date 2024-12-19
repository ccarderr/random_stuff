#!/bin/bash

# Variable for the label of the exFAT partition (easily customizable)
LABEL="shared"

# Variable for the mount point
MOUNT_POINT="/mnt/$LABEL"

# Create the systemd service file to mount the exFAT partition at boot
SERVICE_FILE="/etc/systemd/system/ccrr_mount_shared_partition.service"

echo "Creating systemd service to mount exFAT partition '$LABEL' at boot..."

sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Mount exFAT partition with label '$LABEL'
After=multi-user.target

[Service]
Type=oneshot
ExecStartPre=/bin/mkdir -p "$MOUNT_POINT"
ExecStart=/bin/mount -L "$LABEL" "$MOUNT_POINT"
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
echo "Reloading systemd to recognize the new service..."
sudo systemctl daemon-reload

# Enable the service to start at boot
echo "Enabling the service to start at boot..."
sudo systemctl enable ccrr_mount_shared_partition.service

# Start the service immediately (to mount the partition now)
echo "Starting the service to mount the partition now..."
sudo systemctl start ccrr_mount_shared_partition.service

# Check if the service started successfully
if [ $? -eq 0 ]; then
    echo "Service to mount partition '$LABEL' is successfully installed and started."
else
    echo "Error installing or starting the service to mount partition '$LABEL'."
fi
