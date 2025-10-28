#!/bin/bash
# Configure Amazon Linux instance for SSH and Docker usage.

set -euo pipefail

SSH_PORT=${ssh_port}
SSHD_CONFIG="/etc/ssh/sshd_config"

log() {
  printf '[user-data] %s\n' "$1"
}

log "Updating base packages"
yum update -y

log "Installing base utilities"
yum install -y jq curl wget git

log "Installing Docker engine"
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker

# Add the default user to the docker group if it exists.
if id ec2-user >/dev/null 2>&1; then
  usermod -aG docker ec2-user
fi

log "Configuring SSH to listen on port $SSH_PORT"
if grep -qE "^#?Port " "$SSHD_CONFIG"; then
  sed -i "s/^#\?Port .*/Port $SSH_PORT/" "$SSHD_CONFIG"
else
  printf '\nPort %s\n' "$SSH_PORT" >> "$SSHD_CONFIG"
fi

if command -v semanage >/dev/null 2>&1 && selinuxenabled; then
  log "Updating SELinux policy for custom SSH port"
  semanage port -a -t ssh_port_t -p tcp "$SSH_PORT" 2>/dev/null || \
    semanage port -m -t ssh_port_t -p tcp "$SSH_PORT"
fi

log "Restarting SSH daemon"
systemctl restart sshd

log "User data provisioning complete"
