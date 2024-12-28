# Random Helpful Stuff

## Table of Contents
- [Linux](#linux)
  - [WiFi Delay Service](#wifi-delay-service)
- [Tips and Tricks](#tips-and-tricks)
  - [Preventing SteamDeck from Auto Update](#steamdeck-preventing-auto-update)
  
## Linux

### WiFi Delay Service
A service that disables WiFi at boot and re-enables it after 30 seconds. This can be useful in scenarios where the system needs to start in offline mode, such as skipping updates on a SteamDeck client.
- **Link**: [WiFi Delay Service](linux/wifi_delay_service/)

## Tutorials

### [SteamDeck] Dualboot - Windows Kiosk Mode  
A guide and a set of scripts enabling the installation of Windows alongside SteamOS on internal storage. This setup allows launching Windows games from shortcuts in SteamOS while minimizing interaction with Windows itself. These shortcuts reboot the system into Windows and automatically launch the selected game without user interaction. When the game ends, the system automatically returns to SteamOS.  
- **Link**: [Dualboot - Windows Kiosk Mode](SteamDeck/dualboot_windows_kiosk)

## Tips and Tricks

### [SteamDeck] Preventing Auto Update
To prevent SteamDeck from automatically updating, you can use the [WiFi Delay Service](linux/wifi_delay_service/), which disables WiFi at boot, allowing you to skip updates during startup.
