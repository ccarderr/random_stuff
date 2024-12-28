#!/bin/bash

# Timeout (when waiting for Steam to die)
die_timeout=30
die_retry1=10
die_retry2=15
die_retry3=20
start_time=$(date +%s)

# 1) Define the sudo_pass variable with an empty value
# This value will be used for passing the sudo password to the sudo command
sudo_pass=""

# 2) Define the boot_target variable with an empty value
# An empty value will trigger auto-detection of the boot target.
boot_target=""

# 3) Get the directory path where the script is located
script_dir=$(dirname "$(realpath "$0")")
file_path="$script_dir/ccrr_kiosk_arg.txt"

# 4) Write all arguments to the ccrr_kiosk_arg.txt file
echo "$@" > "$file_path"
echo "Saved all arguments to the ccrr_kiosk_arg.txt file."

# 5) Auto-detect the boot_target if it's not defined
if [ -z "$boot_target" ]; then
    echo "Attempting to auto-detect the boot target..."  # Log about auto-detection attempt
    # Use efibootmgr to get the list of boot entries
    boot_entry=$(efibootmgr -v | grep -i '\\EFI\\Microsoft\\Boot\\bootmgfw.efi')

    # Check if the entry was found
    if [ -n "$boot_entry" ]; then
        # Extract the boot entry number and remove the asterisk
        boot_target=$(echo "$boot_entry" | awk '{print $1}' | sed 's/Boot//' | sed 's/\*//')
        echo "The boot entry number pointing to '\\EFI\\Microsoft\\Boot\\bootmgfw.efi' is: $boot_target"
    else
        echo "No boot entry pointing to '\\EFI\\Microsoft\\Boot\\bootmgfw.efi' found."
    fi
else
    # Log the value of boot_target if it's defined
    echo "boot_target is defined: $boot_target"
fi

# 6) Set the next boot to the boot_target using sudo and the sudo_pass variable
if [ -n "$boot_target" ]; then
    echo "Setting next boot entry to: $boot_target"
    echo "$sudo_pass" | sudo -S efibootmgr -n "$boot_target"  # Pass the sudo password using echo
else
    echo "No valid boot_target found, unable to set next boot."
fi

# 7) Shutdown Steam
steam -shutdown

# 8) Wait for Steam process to die
# Wait for steam to die, no sleep in loop as script has
# to be faster than Steam that restarts imediately,
# if Steam restarts faster, retry up to 3 times,
# force reboot if gracefull shutdown fails
while pgrep -x "steam" > /dev/null; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    # Restart anyway on timeout (assume steam was faster)
    if [ $elapsed -ge $die_timeout ]; then
        reboot
    fi

    # Shutdown Steam (retry1)
    if [ $elapsed -ge $die_retry1 ]; then
        steam -shutdown
    fi

    # Shutdown Steam (retry2)
    if [ $elapsed -ge $die_retry2 ]; then
        steam -shutdown
    fi

    # Shutdown Steam (retry3)
    if [ $elapsed -ge $die_retry3 ]; then
        steam -shutdown
    fi

done

# 7) Reboot the system
echo "Rebooting the system..."
reboot
