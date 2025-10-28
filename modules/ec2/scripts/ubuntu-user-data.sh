#!/bin/bash
# Configure Ubuntu instance for SSH and Docker usage.

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

SSH_PORT=${ssh_port}
SSHD_CONFIG="/etc/ssh/sshd_config"

log() {
  printf '[user-data] %s\n' "$1"
}

log "Updating package index"
apt-get update -y

log "Installing base utilities"
apt-get install -y jq curl wget git apt-transport-https ca-certificates gnupg lsb-release

if ! command -v docker >/dev/null 2>&1; then
  log "Installing Docker engine"
  apt-get install -y docker.io
else
  log "Docker already available, skipping installation"
fi

systemctl enable docker
systemctl start docker

# Add the default user to the docker group if present.
for candidate in ubuntu admin ec2-user; do
  if id "$candidate" >/dev/null 2>&1; then
    usermod -aG docker "$candidate"
  fi
done

log "Configuring SSH to listen on port ${SSH_PORT}"
if grep -qE "^#?Port " "${SSHD_CONFIG}"; then
  sed -i "s/^#\?Port .*/Port ${SSH_PORT}/" "${SSHD_CONFIG}"
else
  printf '\nPort %s\n' "${SSH_PORT}" >> "${SSHD_CONFIG}"
fi

if command -v ufw >/dev/null 2>&1; then
  log "Updating UFW rules for new SSH port"
  ufw allow "${SSH_PORT}/tcp" || true
  ufw delete allow 22/tcp || true
fi

log "Restarting SSH daemon"
systemctl restart sshd || systemctl restart ssh

log "User data provisioning complete"

