# Shutdown Timeout

Reduce timeout before systemd force kills processes on shutdown/reboot (default 90s).

## System services

```bash
sudo mkdir -p /etc/systemd/system.conf.d
sudo tee /etc/systemd/system.conf.d/timeout.conf << 'EOF'
[Manager]
DefaultTimeoutStopSec=1s
EOF
```

## User services

```bash
mkdir -p ~/.config/systemd/user.conf.d
tee ~/.config/systemd/user.conf.d/timeout.conf << 'EOF'
[Manager]
DefaultTimeoutStopSec=1s
EOF
systemctl --user daemon-reload
```

## Shutdown inhibitors

Apps can request a delay before shutdown (e.g. "saving files"). This limits how long they can block:

```bash
sudo mkdir -p /etc/systemd/logind.conf.d
sudo tee /etc/systemd/logind.conf.d/timeout.conf << 'EOF'
[Login]
InhibitDelayMaxSec=1
EOF
```

Reboot to apply

## Manual
`man systemd-system.conf`
`man systemd-user.conf`
`man logind.conf`
