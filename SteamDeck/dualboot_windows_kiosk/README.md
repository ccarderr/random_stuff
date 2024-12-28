(work in progress)

# Dualboot - Windows Kiosk Mode
This tutorial describes how to install Windows alongside SteamOS, with the difference that it will only be used to run individual games in kiosk mode, leaving SteamOS as the main operating system. The setup will work by adding the game to the SteamOS library, and upon launching the game, the SteamDeck will reboot into Windows and start the game. After closing the game, it will reboot back into SteamOS.

## Important Information
This guide was created based on the SteamDeck LCD. The SteamDeck OLED has a different set of drivers for Windows, which means there may be different issues that you will need to solve on your own.

## Table of Contents - Installation and Configuration
- [Requirements](#requirements)
- [SteamOS Imaging (Optional)](#steamos-imaging-optional)
- [Partitioning](#partitioning)
- [Initial Setup](#initial-setup)
- [Windows - Installation](#windows---installation)
- [SteamOS - Checking the GPT Table](#steamos---checking-the-gpt-table)
- [SteamOS - Repairing the GPT Table - Part 1 (Optional)](#steamos---repairing-the-gpt-table---part-1-optional)
- [SteamOS - Repairing the GPT Table - Part 2 (Optional)](#steamos---repairing-the-gpt-table---part-2-optional)
- [SteamOS - Restoring SteamOS as the Default OS (Without Installing Any Bootloaders)](#steamos---restoring-steamos-as-the-default-os-without-installing-any-bootloaders)
- [SteamOS - Mounting Shared Partition](#steamos---mounting-shared-partition)
- [SteamOS - Script Installation](#steamos---script-installation)
- [Windows - Setup](#windows---setup)
- [Windows - Atlas (recommended)](#windows---atlas-recommended)
- [Windows - Script Installation](#windows---script-installation)
--------
- [Usage - Adding Windows Game Shortcuts to SteamOS](#usage---adding-windows-game-shortcuts-to-steamos)
- [Usage - Adding a Shortcut to Windows (Without Launching the Game)](#usage---adding-a-shortcut-to-windows-without-launching-the-game)
- [Usage - Optional Arguments](#usage---optional-arguments)
- [Known Issues](#known-issues)


## Requirements
- Recomended 2TB of internal storage (500GB will be allocated to Windows)
- A USB drive with at least 8GB of capacity
- USB / Bluetooth keyboard
- An adapter or dock allowing the connection of two USB devices and ideally charging simultaneously
- Image burning software (e.g., Rufus) - [LINK](https://rufus.ie/)
- SteamOS image - [LINK](https://store.steampowered.com/steamos/download?ver=steamdeck)
- Windows 11 image - [LINK](https://www.microsoft.com/en-us/software-download/windows11)
- SteamDeck drivers for Windows - [LINK](https://help.steampowered.com/en/faqs/view/6121-ECCD-D643-BAA8)
- (optional) AtlasOS Playbook and AME Wizard - [LINK](https://atlasos.net/)

## SteamOS Imaging (Optional)
It is recommended to restore the SteamDeck to factory settings using an imaging tool to avoid any potential issues caused by mods or other modifications. If you want to preserve your settings, you can skip this step, but I would recommend creating a full disk image as a backup in case you need to restore it later.
- Burn the SteamOS image to the USB drive using Rufus.
- Connect the USB drive to the powered-off SteamDeck using the adapter/dock.
- Press Vol- and Power simultaneously to open the boot menu.
- Select the USB drive from the list to boot the SteamOS installer.
- Reimage SteamOS using the shortcut on the desktop.
- After the imaging is complete, do not reboot; instead, go directly to [#Partitioning](#partitioning).


## Partitioning
- Switch to Desktop mode in SteamOS (if imaging was skipped).
- Launch the partitioning tool (Menu > System > KDE Partition Manager).
- Select the internal disk, right-click on the /home partition, and choose "Resize/Move."
- Reduce the partition size by 500GB (for a 2TB disk), adjusting the value based on your disk capacity and how many games will be installed on Windows. Sizes can be changed later.
- Right-click on the free space and create a 50MB exFAT partition (this will be needed later).
- Right-click again on the exFAT partition, select "Properties," and in the "Label" field, enter `shared`, then click OK.
- The label "shared" will be used by the scripts. If you want, you can assign a different name, but you will need to edit the scripts that reference this label.
- Leave the remaining space empty for the Windows installer.
- Apply the changes.
- If you skipped imaging and cannot resize the partition from SteamOS, reboot into the SteamOS installer and perform the partitioning there.


## Initial Setup
- If you haven't done so already, complete the initial setup of SteamOS and update the system in the settings.

## Windows - Installation
- Burn the Windows image to a USB drive using Rufus, making sure the options to remove requirements (RAM, SecureBoot, TPM, and Microsoft account) are selected.
- Press Vol- and Power simultaneously with the SteamDeck powered off to enter the boot menu.
- Select the USB drive from the list to launch the Windows installer.
- Install the system on the previously prepared partition. If an error appears, delete the partition and install it in the unallocated space.
- When prompted to connect to WiFi, select "I don't have internet."
- Create a local account, the name can be something like "deck" as in SteamOS.
- It is advised not to create a password. If needed, you can configure auto-login later.
- Continue the installation until Windows boots up.

## SteamOS - Checking the GPT Table
- With newer Windows 11 installers, there is a high chance that the GPT table of the disk may have been corrupted, making it impossible to boot SteamOS.
- Check if SteamOS can still boot. Enter the boot menu and see if "SteamOS" is still listed.
- Select SteamOS if it appears in the list. If SteamOS is not on the list or if the GRUB console appears instead of the system, it most likely indicates a corrupted GPT table.
- If SteamOS boots normally, skip the GPT table repair process.

## SteamOS - Repairing the GPT Table - Part 1 (Optional)
- Connect the USB drive with the SteamOS installer, then boot into the installer.
- Launch the "Terminal with repair tools" shortcut.
- Type `lsblk` and press Enter. The "nvme0n1" disk should display at least 8 partitions, but it's likely that none will appear.
- Run the command `sudo fdisk -l /dev/nvme0n1`. You should see a red warning that the GPT table is corrupted, but a backup is available, along with a list of detected partitions.
- Run the command `sudo fdisk /dev/nvme0n1` to start the fdisk tool. The same warning should appear.
- Type `p` and press Enter. A list of detected SteamOS and Windows partitions should appear.
- Type `w` and press Enter to overwrite the GPT table with its recovered copy.
- Reboot into the boot menu, select SteamOS from the list, and check if it boots normally.
- If SteamOS is not listed, proceed to the second part of the repair. If SteamOS is listed and boots, skip the second part.

## SteamOS - Repairing the GPT Table - Part 2 (Optional)
- Press Vol+ and Power simultaneously while the SteamDeck is off to enter the BIOS menu.
- Select "Boot From File", then choose the file path: ESP > efi > steamos > steamcl.efi.
- SteamOS should boot up. Proceed with the initial setup if it hasn't been done already, then switch to Desktop mode.
- Open the Konsole terminal.
- If the sudo password hasn't been set yet, use the command `passwd` to set it.
- Enter the following command to add SteamOS to the boot menu: `sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi"`.
- Enter your password when prompted.
- Reboot the SteamDeck into the boot menu, select SteamOS from the list, and the system should boot.

## SteamOS - Restoring SteamOS as the Default OS (Without Installing Any Bootloaders)
I believe that with this method of using Windows, there is no need to install a bootloader. Booting into Windows will only be necessary for (de)installing and configuring games, with the script responsible for switching between systems. Instead, UEFI can be repaired to boot SteamOS by default.
- Switch SteamOS to Desktop mode.
- Open the Konsole terminal.
- If the sudo password hasn't been set yet, use the command `passwd` to set it.
- Run the command `sudo mount /dev/nvme0n1p1 /mnt` to mount the EFI partition.
- Run the command `sudo cp -r /mnt/EFI/Microsoft /mnt/EFI/Microsoft2` to create a copy of the Windows EFI folder.
- Run the command `sudo cp /mnt/EFI/steamos/steamcl.efi /mnt/EFI/Microsoft2/Boot/bootmgfw.efi` to replace the Windows EFI with SteamOS's.
- Run the command `sudo efibootmgr -c -d /dev/nvme0n1p1 -p 1 -L "SteamOS (custom)" -l '\EFI\Microsoft2\Boot\bootmgfw.efi'` to add a new entry to the boot menu.
- Restart the system and go to the boot menu to ensure that the new entry appears at the top of the list.
- SteamOS is now ready, and you can start using it normally.

## SteamOS - Mounting Shared Partition
- Switch to Desktop mode in SteamOS.
- Download the script [install_ccrr_mount_shared_partition_service.sh](./steamos/install_ccrr_mount_shared_partition_service.sh).
- Right-click the file > Properties > Permissions, check "Is executable," and confirm with OK.
- Right-click the script and select "Run in Konsole."
- Enter the password when prompted.
- From this point, the partition should be automatically mounted on startup in SteamOS.
- To remove the partition mounting service, use the script [uninstall_ccrr_mount_shared_partition_service.sh](./steamos/uninstall_ccrr_mount_shared_partition_service.sh).

## SteamOS - Script Installation
- Open the file manager (Dolphin) and navigate to the newly mounted "shared" partition from the left-hand menu.
- Create a new folder named "ccrr_kiosk" and navigate into it (you can name it differently if desired).
- Download the scripts [ccrr_kiosk_reboot_to_windows.sh](./kiosk/ccrr_kiosk_reboot_to_windows.sh) and [ccrr_kiosk_watcher.ps1](./kiosk/ccrr_kiosk_watcher.ps1) and place them in the "ccrr_kiosk" directory.
- The script for rebooting to Windows requires sudo, which normally prompts for a password, but this can be bypassed:
- Open the file "ccrr_kiosk_reboot_to_windows.sh" with a text editor (Kate).
- Locate the line `sudo_pass=""` and enter your sudo password between the quotation marks, e.g., `sudo_pass="my_pass"`, then save the file.
- The initial configuration of SteamOS is now complete. We will proceed to Windows setup next.

## Windows - Setup
- Reboot into the boot menu and boot into Windows.
- Optionally, for convenience, install remote assistance software (e.g., AnyDesk) and continue the setup from another computer.
- Begin by installing the drivers: APU, WiFi, Bluetooth, SD card*, and audio. Follow the order specified for audio drivers on the website where you downloaded them.
  - **[Important]** The SD card drivers may be unstable. If you do not plan to use an SD card, do not install these drivers. It's better to disable the SD card reader in Device Manager.
- After installing the drivers, restart the system. Adjust the screen orientation and, optionally, reduce the scaling for better usability.
- Open system settings, navigate to taskbar settings, hide unnecessary items, and ensure the on-screen keyboard button is always visible (this will help if SteamInput is unavailable).
- Download and install Steam, then log in.
- Go to system settings, Windows Update, download any available system and driver updates, and restart. After rebooting, verify that no further updates are available.
- Optionally, hide the EFI partitions in "This PC":
  - Right-click the Start menu and select **Disk Management**.
  - Find the EFI partitions with an assigned drive letter, right-click it, and select **Change Drive Letter and Paths**. Then, remove the drive letter.
  - You can also change the drive letter for the "shared" partition to one of your choice.


## Windows - Atlas (recommended)
- AME Wizard and Atlas are used to trim down the Windows system, improve its performance, disable Windows Update, and optionally disable Defender. This is not a required step, but Windows updates can be very bothersome, slowing down the SteamDeck and increasing the time it takes to switch between SteamOS and Windows. Keep in mind that Windows is originally resource-hungry, and the SteamDeck has just under 15GB of RAM.
- Launch the AME Wizard program and drag the AtlasPlaybook file to the appropriate area in the AME Wizard window.
- Disable security features as instructed by the program, then proceed.
- You will be presented with an option to disable Windows Defender. Since the system will only be used for gaming specific games, disabling it should not pose a significant risk if you do not plan to install anything from untrusted sources. However, the choice is yours - security or performance.
- Leave the default Windows Mitigation enabled.
- Disable automatic updates in Windows Update.
- Hibernate can be left disabled as audio drivers tend to break upon resuming, and restarting them can cause games to crash or mute.
- Do not disable power-saving features, as we want to keep them active, since the SteamDeck mainly runs on battery.
- Core isolation can be disabled for better performance, but some anti-cheat systems may not like this, so it's up to you.
- The remaining options are up to your discretion.
- Once the configuration is complete, continue. AME Wizard will optimize the system and automatically reboot it.

## Windows - Script Installation
- First, open Steam, go to its settings, and disable the auto-start at system boot. Then, completely close Steam.
- Go to "This PC" and make sure the "shared" partition is mounted (it has an assigned drive letter).
- Right-click the Start menu and select "Computer Management."
- Navigate to "Task Scheduler > Task Scheduler Library."
- Select "Create Task" (not basic).
- Enter the name "Autostart - Steam."
- Check "Run with highest privileges" at the bottom.
- Go to the "Triggers" tab and add a new one.
- Set "Begin the task: At logon" and select "Specific user," then confirm with OK.
- Go to the "Actions" tab and add a new one.
- Choose "Action: Start a program."
- In the "Program/script" field, enter `powershell`.
- In the "Add arguments" field, enter `-WindowStyle Minimized -File F:\kiosk_mode\ccrr_kiosk_watcher.ps1` (adjust the file path to fit your configuration!).
- Confirm with OK.
- Go to the "Conditions" tab and uncheck all options.
- Go to the "Settings" tab and uncheck "Stop the task if it runs longer than: x."
- Create the new task by clicking OK.
- To test if the task works, right-click the task and select "Run."
- If set correctly, Steam should launch with administrator privileges.
  - [Note] Administrator privileges are important for Steam Input to interact with elevated windows (like most online games). It will still not interact with UAC windows, as those run as SYSTEM.
- The setup is complete, and the script is ready for use.
 

 
# Usage - Adding Windows Game Shortcuts to SteamOS
- Reboot into Windows.
- Install the desired game, it can be a Steam or non-Steam game.
- For non-Steam games, add the game to your Steam library.
- Right-click on the game in the Steam library and select Properties.
- Add the launch argument `-ccrr_kiosk` and close the window (the script will monitor processes launched with this argument).
  - For games launched from other stores (e.g., Epic), instead of adding the argument to the Steam library shortcut, add it to the game’s properties in the respective store. Otherwise, the script will monitor the store instead of the game, or if the store was already running in the background, the monitoring may fail.
  - Similarly, this can be done for games where the launcher completely closes after the game starts (since the script monitors the launcher).
- Right-click the game in the Steam library, select "Manage > Add Desktop Shortcut."
- Open the properties of the newly created shortcut, copy the game ID from the URL (`steam://rungameid/game_id`).
- Create a text file on the shared partition, e.g., "F:\\kiosk_mode\game_ids.txt."
- Add a line to the file in the format "Game Name - game_id" for clarity. You can use this file to store Windows game IDs for later use.
- That’s it for Windows. Reboot into SteamOS and switch to Desktop mode.
- Open the file manager (Dolphin), navigate to "\shared\kiosk_mode," open the "game_ids.txt" file, and copy the game ID.
- Open Steam, add a non-Steam game, click "Browse...", locate the file "\shared\kiosk_mode\ccrr_kiosk_reboot_to_windows.sh", and add it to Steam.
- Right-click on the newly added item in the Steam library and select Properties.
- Change the shortcut name to the game name.
- Add the following arguments `-appid 01234 &` (replace 01234 with the game ID number, the "&" argument is mandatory and should always be at the end).
- Close the properties window.
- Run the game to test if everything works. The system should reboot into Windows and automatically launch the game in Big Picture mode without user interaction.

# Usage - Adding a Shortcut to Windows (Without Launching the Game)
- Add a shortcut to the script "\shared\kiosk_mode\ccrr_kiosk_reboot_to_windows.sh" without the `-appid` argument, leaving just `&` (this will launch Windows and Steam in Desktop mode, without monitoring the game).

# Usage - Optional Arguments
- `-nobigpicture` - When launching a game, Steam will start in desktop mode instead of Big Picture mode.

# Known Issues
- **When I launch a game on SteamOS, nothing happens**
  - Ensure that the "shared" partition is mounted at system startup (automatic mounting typically occurs 5-10 seconds after SteamOS boots).
  - Verify that you entered the correct sudo password in the "ccrr_kiosk_reboot_to_windows.sh" script.

- **SteamOS reboots back to SteamOS instead of switching to Windows**
  This behavior can be caused by two issues: either the Steam client (gamemode) restarts so quickly that the script fails to detect when it has been closed (SteamOS immediately restarts Steam in game mode when you close it via the command line), or the automatic detection of the Windows EFI entry fails.

  - **If Steam restarts too quickly:**
    - Try launching the game again or hold the power button to restart (NextBoot is likely still pointing to Windows).

  - **If the Windows EFI entry is not detected correctly:**
    - Switch to desktop mode.
    - Open the terminal (Konsole).
    - Run the command `efibootmgr -v`.
    - Locate the "Windows Boot Manager" entry and note its number. For example, in "Boot0002* Windows Boot Manager", the number is "0002".
    - Edit the file "\shared\kiosk_mode\ccrr_kiosk_reboot_to_windows.sh."
    - Find `boot_target=""` and set the number, e.g., `boot_target="0002"`.
    - From now on, automatic detection will be disabled, and the specified entry will be used.


(work in progress)
