## Pre-requisites for uninstalling k3s

Some Linux hosts are configured to allow `sudo` to run without having to repeat your password. For those which are not already configured that way, you'll nee to make the following changes if you wish to unsintsall `k3s`

```bash
# sudo visudo

# Then add to the bottom of the file
# replace "user" with your username i.e. "ubuntu"
user ALL=(ALL) NOPASSWD: ALL
```
> Note: You can copy ssh keys to a remote VM with `ssh-copy-id user@IP`.
