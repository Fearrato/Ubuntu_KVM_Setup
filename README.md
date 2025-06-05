# Ubuntu KVM Virtualization Setup

This repository provides a comprehensive script to install, configure, and enable KVM virtualization with GUI management and Cockpit web interface on Ubuntu 22.04 LTS and newer (including Ubuntu 24.04 codename *noble*).

---

## Contents

- `KVM_virtualization.sh`: Bash script automating the full setup
- Step-by-step guide in this README

---

## Features

- Installs and configures KVM, QEMU, and libvirt virtualization stack
- Installs **Virt-Manager** GUI for managing virtual machines
- Enables and configures **Cockpit** web interface with `cockpit-machines` for virtualization management via browser
- Adds current user to `kvm` and `libvirt` groups for seamless permissions
- Sets up the default NAT network and enables essential services (`libvirtd`, `virtlogd`, `cockpit`)
- Creates an ISO storage directory under the user's home folder (`~/VMs/ISO`)
- Optionally downloads the latest VirtIO Windows drivers ISO for Windows guests
- Ensures Virt-Manager GUI integration and desktop menu visibility

---

## Requirements

- Ubuntu 22.04 LTS or newer (tested on 24.04 *noble*)
- User with sudo privileges
- Internet connection for package downloads

---

## Usage

1. Clone or download this repository:

   ```bash
   git clone https://github.com/Fearrato/Ubuntu_KVM_Setup.git
   cd Ubuntu_KVM_Setup
   
   chmod +755 Ubuntu_KVM_Setup.sh
   sudo ./Ubuntu_KVM_Setup.sh

