# Thunar Configuration

## Polkit rule for Thunar (allow mounting without authentication)
```bash
sudo tee /etc/polkit-1/rules.d/50-udisks.rules > /dev/null << 'EOF'
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.udisks2.") == 0 &&
        (subject.isInGroup("wheel") || subject.isInGroup("users"))) {
        return polkit.Result.YES;
    }
});
EOF
sudo systemctl restart polkit
```
