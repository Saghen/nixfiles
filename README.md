# SOPS

Updating the keys when adding new hosts: `nsp sops` then `sops updatekeys keys/sops/whatever.yaml`

GPG for encryption
SSH for decryption (by converting the SSH to Age) using the default host key, it generates it automatically at /etc/ssh/id_smthsmth. You can get the age via the `ssh-to-age` tool like `cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age`
