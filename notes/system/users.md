# User Management

## Listing Users

```bash
# All users
cut -d: /etc/passwd -f1

# "Real" users (UID >= 1000, excluding nobody)
awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd

# Current user's groups
id
groups

# Members of a specific group
getent group wheel
```

## Creating Users

```bash
useradd -m username -s /bin/bash   # -m creates home dir
passwd username                     # set password
```

## Deleting Users

```bash
userdel username       # keep home directory
userdel -r username    # delete home directory too
```

## Groups

```bash
# Add user to group
usermod -aG group user

# Remove user from group
gpasswd -d user group

# Change primary group
usermod -g group user
```

### Sudo Access

All distros use `/etc/sudoers` (edit with `visudo`). The file references a group:

| Distro | Admin group |
|--------|-------------|
| Arch, Fedora, RHEL | `wheel` |
| Debian, Ubuntu | `sudo` |

On Arch, `/etc/sudoers` contains:
```
%wheel ALL=(ALL:ALL) ALL
```
The `%` prefix means "group". Being in `wheel` alone does nothing without this line.

## File Permissions

Permission bits: `rwxrwxrwx` = user | group | other

Checked in order (first match wins):
1. Owner → user bits apply
2. In file's group → group bits apply
3. Everyone else → other bits apply

```bash
# Change ownership
chown user:group path
chown -R user:group path   # recursive
```

### umask

Sets default permissions for newly created files by masking bits off.

```bash
umask         # show current
umask 022     # set new value
```

| umask | Files | Directories | Effect |
|-------|-------|-------------|--------|
| 022 | 644 (rw-r--r--) | 755 (rwxr-xr-x) | default, others read-only |
| 002 | 664 (rw-rw-r--) | 775 (rwxrwxr-x) | group-writable |
| 077 | 600 (rw-------) | 700 (rwx------) | private, only owner |

Use case: if user `alice` and `bob` share group `project`, set `umask 002` so
files they create are editable by each other without chown.

## Sandboxing a Process

```bash
# Run command as another user, no network
sudo unshare --net -- su username -c "command"

# Interactive shell, no network
sudo unshare --net -- su username
```

`unshare --net` creates an empty network namespace (no interfaces).

## Special Users

- `nobody` (UID 65534): minimal privileges, owns nothing, used for untrusted processes

## Manual
`man useradd` `man userdel` `man usermod` `man gpasswd` `man chown` `man unshare`
