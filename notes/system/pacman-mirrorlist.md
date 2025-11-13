# Updating pacman mirrorlist
⚠️ Might take an hour or more
```bash
sudo reflector --latest 500 --protocol https --connection-timeout 10 --download-timeout 10 --sort rate --save /etc/pacman.d/mirrorlist
```
see 
```bash
reflector --help
```

