# Systemd Shutdown Timeout

Reduce timeout before systemd force kills services (default 90s).

```bash
sudo mkdir -p /etc/systemd/system.conf.d
sudo tee /etc/systemd/system.conf.d/timeout.conf << 'EOF'
[Manager]
DefaultTimeoutStopSec=1s
EOF
```
