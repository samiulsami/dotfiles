# Keyboard Configuration

## Fix keyboard Fn keys not-registering issue
```bash
echo "options hid_apple fnmode=0" | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo mkinitcpio -P
```

## References
- [https://mikeshade.com/posts/keychron-linux-function-keys/](https://mikeshade.com/posts/keychron-linux-function-keys/)
