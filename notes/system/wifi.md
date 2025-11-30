# WiFi Configuration with iwd

## Connect to WiFi

```bash
iwctl
device list
station <device> scan
station <device> get-networks
station <device> connect <network-name>
```

## Enable iwd service

```bash
sudo systemctl enable --now iwd
```

## Disconnect

```bash
iwctl station <device> disconnect
```

## Show connected network

```bash
iwctl station <device> show
```

## Manual
`man iwctl`, `man iwd`
