(work in progress)

# Dualboot - Windows Kiosk Mode
This tutorial describes how to install Windows alongside SteamOS, with the difference that it will only be used to run individual games in kiosk mode, leaving SteamOS as the main operating system. The setup will work by adding the game to the SteamOS library, and upon launching the game, the SteamDeck will reboot into Windows and start the game. After closing the game, it will reboot back into SteamOS.

## Important Information
This guide was created based on the SteamDeck LCD. The SteamDeck OLED has a different set of drivers for Windows, which means there may be different issues that you will need to solve on your own.

## Requirements
- 2TB of internal storage (500GB will be allocated to Windows)
- A USB drive with at least 8GB of capacity
- USB / Bluetooth keyboard
- An adapter or dock allowing the connection of two USB devices and ideally charging simultaneously
- Image burning software (e.g., Rufus) - [LINK](https://rufus.ie/)
- SteamOS image - [LINK](https://store.steampowered.com/steamos/download?ver=steamdeck)
- Windows 11 image - [LINK](https://www.microsoft.com/en-us/software-download/windows11)
- AtlasOS Playbook and AME Wizard - [LINK](https://atlasos.net/)
- SteamDeck drivers for Windows - [LINK](https://help.steampowered.com/en/faqs/view/6121-ECCD-D643-BAA8)

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
- Select the internal disk, right-click on the /home partition, and choose "Resize/Move".
- Reduce the partition size by 500GB (for a 2TB disk), adjusting the value based on your disk capacity and how many games will be installed on Windows. Sizes can be changed later.
- Right-click on the free space and create an NTFS partition for Windows, leaving about 50MB of free space at the end of the disk.
- Right-click on the remaining 50MB of free space and create an exFAT partition (if it throws an error, reduce the size by 1MB until it works).
- Apply the changes.
- If you skipped imaging and cannot resize the partition from SteamOS, reboot into the SteamOS installer and perform the partitioning there.

## Initial Setup
- If you haven't done so already, complete the initial setup of SteamOS and update the system in the settings.

## Windows - Installation
- Burn the Windows image to a USB drive using Rufus, making sure the options to remove requirements (RAM, SecureBoot, TPM, and Microsoft account) are selected.
- Press Vol- and Power simultaneously with the SteamDeck powered off to enter the boot menu.
- Select the USB drive from the list to launch the Windows installer.
- Install the system on the previously prepared partition. If an error appears, delete the partition and install it in the unallocated space.
- When prompted to connect to WiFi, select "I don't have internet".
- Create a local account, the name can be something like "deck" as in SteamOS.
- It is advised not to create a password. If needed, you can configure auto-login later.
- Continue the installation.

## Windows - Setup
- Optionally, to increase convenience, you can install remote assistance software (e.g., AnyDesk) and continue the setup by connecting from another computer.
- First, install the drivers (APU, WiFi, Bluetooth, SD card, and audio). The order for installing audio drivers can be found on the website from which you downloaded the drivers.
- After installing the drivers, restart the system, adjust the screen orientation, and optionally reduce the scaling.
- Go to system settings, taskbar settings, hide unnecessary items, and make sure the on-screen keyboard button is always visible (this will be useful if SteamInput cannot be used).
- Download and install Steam, then log in.
- Go to system settings, Windows Update, download any available system and driver updates, and restart. After rebooting, make sure there are no more updates.

## Windows - Elevate Steam
- An important step is granting Steam administrator privileges so it can interact with applications requiring elevated permissions (as most online games do today). This will still not allow interaction with UAC windows, as they run as SYSTEM, and running Steam as SYSTEM would cause numerous issues.
- Open Task Manager, go to the Startup tab, and disable Steam.
- Right-click on the Start menu and select "Computer Management."
- Go to the Task Scheduler library and create a new task (not a basic task).
- Enter the name "Autostart Steam," and check the option to run with highest privileges at the bottom of the window.
- Go to the Triggers tab, add a new trigger, start the task at user login, and select your user as the specified user. Apply.
- Go to the Actions tab, add a new action, and copy the path to the program and the Startup folder from the Steam shortcut properties on your desktop.
- Add the arguments "-noverifyfiles -gamepadui," and apply.
- Go to the Conditions tab and uncheck all options.
- Go to the Settings tab and uncheck the option to stop the task if it runs longer than X days.
- Click OK to create the task.
- Restart the system, and Steam should launch in Big Picture mode with admin privileges.

## Windows - Atlas (recommended)
- ALE Wizard and Atlas are used to trim down the Windows system, improve its performance, disable Windows Update, and optionally disable Defender. This is not a required step, but Windows updates can be very bothersome, slowing down the SteamDeck and increasing the time it takes to switch between SteamOS and Windows. Keep in mind that Windows is originally resource-hungry, and the SteamDeck has just under 15GB of RAM.
- Launch the AME Wizard program and drag the AtlasPlaybook file to the appropriate area in the AME Wizard window.
- Disable security features as instructed by the program, then proceed.
- You will be presented with an option to disable Windows Defender. Since the system will only be used for gaming specific games, disabling it should not pose a significant risk if you do not plan to install anything from untrusted sources. However, the choice is yours - security or performance.
- Leave the default Windows Mitigation enabled.
- Disable automatic updates in Windows Update.
- Hibernate can be left disabled as audio drivers tend to break upon resuming, and restarting them can cause games to crash or mute.
- Do not disable power-saving features, as we want to keep them active, since the SteamDeck mainly runs on battery.
- Core isolation can be disabled for better performance, but some anti-cheat systems may not like this, so it's up to you.
- The remaining options are up to your discretion.
- Gdy zakończysz konfigurację, kontunuuj. AME Wizard przeprowadzi optymalizację systemu i automatycznie uruchomi go ponownie.


- 

  
(work in progress)
