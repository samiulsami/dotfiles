# System Configuration

## Increase file watch numbers
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

## References
- [https://unix.stackexchange.com/a/530226/732495](https://unix.stackexchange.com/a/530226/732495)
