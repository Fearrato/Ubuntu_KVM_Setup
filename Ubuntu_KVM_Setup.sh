#!/bin/bash
# KVM & Cockpit virtualization setup script for Ubuntu 22.04+ (e.g. noble, jammy)
# Author: Fearrato
# License: MIT

set -e

# ----------------------------- SYSTEM CHECK -----------------------------

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root (e.g., sudo ./KVM_virtualization.sh)"
  exit 1
fi

UBUNTU_CODENAME=$(lsb_release -sc 2>/dev/null || echo "unknown")
echo "📦 Detected Ubuntu codename: $UBUNTU_CODENAME"

# -------------------------- PACKAGE INSTALLATION ------------------------

echo "🔧 Installing virtualization components..."
apt-get update

# Current recommended packages for Ubuntu 20.10+ (libvirt-bin is obsolete)
apt-get install -y \
  qemu-system-x86 \
  qemu-utils \
  virt-manager \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virtinst \
  libguestfs-tools \
  libosinfo-bin \
  gir1.2-gtk-3.0 \
  policykit-1 \
  wget \
  cockpit \
  cockpit-machines

# -------------------------- USER PERMISSIONS ----------------------------

TARGET_USER=${SUDO_USER:-${USER}}

echo "👤 Adding user '$TARGET_USER' to virtualization groups..."
usermod -aG kvm "$TARGET_USER"
usermod -aG libvirt "$TARGET_USER"

# ---------------------------- LIBVIRT SETUP -----------------------------

echo "🖧 Enabling libvirt default NAT network..."
virsh net-autostart default >/dev/null 2>&1 || true
virsh net-start default >/dev/null 2>&1 || true

echo "⚙️ Enabling virtualization services..."
systemctl enable --now libvirtd.service virtlogd.service

# --------------------------- COCKPIT SETUP ------------------------------

echo "🌐 Enabling Cockpit web UI..."
systemctl enable --now cockpit.socket

# -------------------------- ISO DIRECTORY SETUP -------------------------

ISO_DIR="/home/$TARGET_USER/VMs/ISO"
echo "💽 Creating ISO storage directory at: $ISO_DIR"
mkdir -p "$ISO_DIR"
chown "$TARGET_USER:$TARGET_USER" "$ISO_DIR"
chmod 755 "$ISO_DIR"

# ---------------------- OPTIONAL: VIRTIO ISO DOWNLOAD -------------------

VIRTIO_URL="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"
VIRTIO_PATH="$ISO_DIR/virtio-win.iso"

if [ ! -f "$VIRTIO_PATH" ]; then
  echo "⬇️ Downloading VirtIO ISO for Windows VMs..."
  wget -O "$VIRTIO_PATH" "$VIRTIO_URL" || echo "⚠️ Failed to download VirtIO ISO."
fi

# ----------------------- GUI VALIDATION FIX -----------------------------

echo "🧩 Ensuring Virt-Manager appears in the GUI..."
update-desktop-database /usr/share/applications || true

# ----------------------------- FINISH -----------------------------------

echo "✅ KVM virtualization setup complete!"
echo "ℹ️ Reboot or log out and back in to apply group changes."
echo "🚀 You can now launch Virt-Manager from the app menu or run: virt-manager"
echo "🌐 Cockpit web UI available at: https://localhost:9090"
echo "📂 ISO images directory: $ISO_DIR"

