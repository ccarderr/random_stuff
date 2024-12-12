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

## Tips and Tricks

### [SteamDeck] Preventing Auto Update
To prevent SteamDeck from automatically updating, you can use the [WiFi Delay Service](linux/wifi_delay_service/), which disables WiFi at boot, allowing you to skip updates during startup.
