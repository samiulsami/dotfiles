# NVMe SSD Power Management

```bash
# List the available nvme devices
nvme list

# List available power states for NVMe drive (assuming nvme1 is the required drive)
sudo nvme id-ctrl /dev/nvme1

# Get current power management features
sudo nvme get-feature /dev/nvme1 -H

# Set lower power state to reduce temperature (0=highest performance, higher numbers=lower power)
sudo nvme set-feature /dev/nvme1 --feature-id=2 --value=2

# Automate power state setting on boot (create systemd service)
sudo tee /etc/systemd/system/nvme-powersave.service << 'EOF'
[Unit]
Description=Set NVMe power state for HP SSD
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/nvme set-feature /dev/nvme1 --feature-id=2 --value=2

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable nvme-powersave.service
sudo systemctl start nvme-powersave.service

# Verify service status
sudo systemctl status nvme-powersave.service
```
