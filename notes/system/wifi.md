# WiFi Configuration with NetworkManager

## Connect to WiFi

```bash
# List available networks
nmcli device wifi list

# Connect to a network
nmcli device wifi connect <network name> --ask
```

## Enable NetworkManager service

```bash
sudo systemctl enable --now NetworkManager
```

## Disconnect

```bash
nmcli connection down "connection-name"
```

## Show connection status

```bash
nmcli device status
nmcli connection show
```

## Connect to saved network

```bash
nmcli connection up "connection-name"
```

## Manual
`man nmcli`
