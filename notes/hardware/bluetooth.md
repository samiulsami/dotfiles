# Bluetooth Configuration

## Connect to bluetooth device manually
```bash
bluetoothctl
power on  # in case the bluez controller power is off
agent on
scan on  # wait for your device's address to show up here
scan off
trust MAC_ADDRESS
pair MAC_ADDRESS
connect MAC_ADDRESS
```

## Manual
`man bluetoothctl`

## References
- [https://unix.stackexchange.com/a/530226/732495](https://unix.stackexchange.com/a/530226/732495)
