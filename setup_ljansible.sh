#!/bin/bash
set -e

################################# CREAR USUARIO Y CONFIGURAR SSH 
USERNAME="ljansible"
SSH_PUB_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9tAu/9cZIZXAn6H02WC/VeBFjZh/720ENshziDqIN0 ljansible"

if [ "$EUID" -ne 0 ]; then
  echo "Ejecutar como root: sudo bash $0"
  exit 1
fi

useradd -m -s /bin/bash "$USERNAME"
passwd -d "$USERNAME"

if ! grep -q "^${USERNAME} ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
  echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

mkdir -p /home/${USERNAME}/.ssh
echo "$SSH_PUB_KEY" >> /home/${USERNAME}/.ssh/authorized_keys
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh
chmod 700 /home/${USERNAME}/.ssh
chmod 600 /home/${USERNAME}/.ssh/authorized_keys

echo "Usuario $USERNAME creado y configurado correctamente."
