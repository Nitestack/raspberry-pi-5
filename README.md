<div align="center">
<h1>
  🍓 Raspberry Pi 5
  <br/>
  Home Server
  <br/>
  <sup>
    <sub>Powered by <a href="https://www.ansible.com/" target="_blank">Ansible</a></sub>
  </sup>
</h1>

![Latest Commit](https://img.shields.io/github/last-commit/Nitestack/raspberry-pi-5?style=for-the-badge)
![GitHub Repo Stars](https://img.shields.io/github/stars/Nitestack/raspberry-pi-5?style=for-the-badge)
![Github Created At](https://img.shields.io/github/created-at/Nitestack/raspberry-pi-5?style=for-the-badge)

[Features](#-features) • [Requirements](#️-requirements) • [Getting Started](#-getting-started) • [Port Forwarding](#-port-forwarding) • [Environment Variables](#-environment-variables) • [Security](#-security) • [License](#-license)

_This [Ansible](https://www.ansible.com) configuration automates the setup of a Raspberry Pi Home Server running [Raspberry Pi OS](https://www.raspberrypi.com/software). It deploys essential services, enhances security, and ensures consistency across the server environment._

<p>
  <strong>If you find this repository useful, please <a href="#" title="star">⭐️</a> or fork it!</strong>
</p>
</div>

## 🚀 Features

> [!Warning]
> This setup requires your domain to be fully managed by Cloudflare DNS.

- **Automated Docker Installation**
- **Vaultwarden Deployment** for secure password management
- **Cloudflare DDNS Updater** for dynamic IP management
- **PiVPN (WireGuard)** configuration for secure remote access
- **NextCloud** for file synchronization and sharing
- **Immich** for media synchronization with fast-upload speeds
- **Ente Auth** for a cross-platform 2FA solution
- **Glance** dashboard for a unified news feed and monitoring of the home lab
- **AdGuard Home** for ad-blocking and privacy protection
- **Beaver Habits Tracker** for habit tracking
- **Dotfiles** for a standardized environment
- **Personal Site** for hosting your personal website

## ⚙️ Requirements

1. **Raspberry Pi OS Lite (64-bit)**: Ensure your Raspberry Pi is running the latest version.
2. **Ansible**: Install Ansible on your local machine.
3. **Cloudflare-managed domain**: Required for dynamic DNS updates and subdomain routing.
4. **Ethernet connection**: Use a wired connection for your Raspberry Pi to ensure stable performance.

> [!Important]
> When flashing your SD card, enable SSH and select the `Use password authentication` option.

> [!Note]
> If you choose a custom hostname or user, remember to update the `inventory.ini` file accordingly.

5. **Static IPv4 configuration**: Your Raspberry Pi should have a static IP on your local network. To set the IP to `192.168.2.210`, use:

   ```sh
   sudo nmcli con mod "Wired connection 1" ipv4.addresses "192.168.2.210/24" \
     ipv4.gateway "192.168.2.1" \
     ipv4.dns "192.168.2.1" \
     ipv4.method manual && \
   sudo nmcli con up "Wired connection 1"
   ```

   This is a one-time setup. The Ansible playbook will manage IP persistence afterward.

> [!Note]
> Ensure Avahi is installed and running for `.local` domain resolution. Alternatively, access the Pi using its IP address directly.

## 🏁 Getting Started

1. **Clone the repository**:

   ```sh
   git clone https://github.com/Nitestack/raspberry-pi-5.git ~/raspberry-pi-5
   ```

2. **Install required Ansible Galaxy collections**:

   ```sh
   ansible-galaxy install -r requirements.yml --force # to ensure the latest versions
   ```

3. **Run the playbook**:

   ```sh
   ansible-playbook -i inventory.ini playbook.yml
   ```

> [!IMPORTANT]
> This only works if you have set up password-less authentication on your Raspberry Pi. Please look at the [Security](#-security) section for more details.

## 🔌 Port Forwarding

To ensure remote access and proper functionality of the services, configure the following port forwarding rules on your router:

```plaintext
# PiVPN (WireGuard)
# PIVPN_PORT is an environment variable configurable in `secrets.yml`. The default value is `51820`.
public:${PIVPN_PORT}/tcp -> local:${PIVPN_PORT}/tcp

# Caddy (handling all the websites and API's)
public:443/tcp -> local:443/tcp
public:443/udp -> local:443/udp

# SSH (optional, if you want to access the Raspberry Pi with an URL)
public:22/tcp -> local:22/tcp
```

## 🛠️ Environment Variables

To securely configure sensitive data, create a `secrets.yml` file in the root directory. Copy the `secrets.example.yml` file and populate the fields as required.

### Cloudflare

Please set up an API token with `CLOUDFLARE_API_TOKEN` with `Edit zone DNS` permissions. This token is used to update your dynamic IP address in Cloudflare.

### Glance Settings

Please set a GitHub personal access token with `GITHUB_API_TOKEN` (check this [article](https://docs.github.com/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)).

### Immich Settings

Please set your timezone id (TZ identifier) with `TIMEZONE` (check this [Wikipedia article](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)).

## 🛡️ Security

### 1. Add Your Host to Authorized Keys on the Raspberry Pi

To enable secure SSH access, copy your public key to the Raspberry Pi:

```sh
ssh-copy-id nhan@npham.de
```

### 2. Update SSH Configuration

Edit the `/etc/ssh/sshd_config` file on the Raspberry Pi to strengthen security. Update the following settings:

```plaintext
PasswordAuthentication no
UsePAM no
```

### 3. Reload the SSH Service

Apply the changes by reloading the SSH service:

```sh
sudo systemctl reload ssh
```

## 📝 License

This project is licensed under the Apache-2.0 license.
