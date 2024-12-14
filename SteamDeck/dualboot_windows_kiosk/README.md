(work in progress)

# Dualboot - Windows Kiosk Mode
This tutorial describes how to install Windows alongside SteamOS, with the difference that it will only be used to run individual games in kiosk mode, leaving SteamOS as the main operating system. The setup will work by adding the game to the SteamOS library, and upon launching the game, the SteamDeck will reboot into Windows and start the game. After closing the game, it will reboot back into SteamOS.

## Requirements
- 2TB of internal storage (500GB will be allocated to Windows)
- A USB drive with at least 8GB of capacity
- USB / Bluetooth keyboard
- An adapter or dock allowing the connection of two USB devices and ideally charging simultaneously
- Image burning software (e.g., Rufus) - [https://rufus.ie/](https://rufus.ie/)
- SteamOS image - [https://store.steampowered.com/steamos/download?ver=steamdeck](https://store.steampowered.com/steamos/download?ver=steamdeck)
- Windows 11 image - [https://www.microsoft.com/en-us/software-download/windows11](https://www.microsoft.com/en-us/software-download/windows11)
- AtlasOS Playbook and AME Wizard - [https://atlasos.net/](https://atlasos.net/)
- SteamDeck drivers for Windows - [https://help.steampowered.com/en/faqs/view/6121-ECCD-D643-BAA8](https://help.steampowered.com/en/faqs/view/6121-ECCD-D643-BAA8)

## SteamOS Imaging (Optional)
It is recommended to restore the SteamDeck to factory settings using an imaging tool to avoid any potential issues caused by mods or other modifications. If you want to preserve your settings, you can skip this step, but I would recommend creating a full disk image as a backup in case you need to restore it later.
- Burn the SteamOS image to the USB drive using Rufus.
- Connect the USB drive to the powered-off SteamDeck using the adapter/dock.
- Press Vol- and Power simultaneously to open the boot menu.
- Select the USB drive from the list to boot the SteamOS installer.
- Reimage SteamOS using the shortcut on the desktop.
- After the imaging is complete, do not reboot; instead, go directly to ##Partitioning.

## Partitioning
- Switch to Desktop mode in SteamOS (if imaging was skipped).
- Launch the partitioning tool (Menu > System > KDE Partition Manager).
- Select the internal disk, right-click on the /home partition, and choose "Resize/Move".
- Reduce the partition size by 500GB (for a 2TB disk), adjusting the value based on your disk capacity and how many games will be installed on Windows. Sizes can be changed later.
- Right-click on the free space and create an NTFS partition for Windows, leaving about 50MB of free space at the end of the disk.
- Right-click on the remaining 50MB of free space and create an exFAT partition (if it throws an error, reduce the size by 1MB until it works).
- Apply the changes.
- If you skipped imaging and cannot resize the partition from SteamOS, reboot into the SteamOS installer and perform the partitioning there.

(work in progress)
