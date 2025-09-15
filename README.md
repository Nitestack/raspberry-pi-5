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

[Features](#-features) • [Requirements](#️-requirements) • [Getting Started](#-getting-started) • [Configuration](#%EF%B8%8F-configuration) • [Port Forwarding](#-port-forwarding) • [Security](#%EF%B8%8F-security) • [License](#-license)

_This [Ansible](https://www.ansible.com) configuration automates the setup of a Raspberry Pi Home Server running [Raspberry Pi OS](https://www.raspberrypi.com/software). It deploys essential services using a modern, secure, and declarative best-practice architecture._

<p>
  <strong>If you find this repository useful, please <a href="#" title="star">⭐️</a> or fork it!</strong>
</p>
</div>

## 🚀 Features

> [!Warning]
> This setup requires your domain to be fully managed by Cloudflare DNS.

- **Automated Docker Installation** following the latest security best practices.
- **Dynamic Firewall Configuration** with UFW that automatically adapts to your services.
- **Vaultwarden** for secure password management.
- **Cloudflare DDNS Updater** for dynamic IP management.
- **WireGuard Easy** for secure remote access.
- **NextCloud** for file synchronization and sharing.
- **Immich** for media synchronization with fast-upload speeds.
- **Ente Auth** for a cross-platform 2FA solution.
- **Glance** dashboard for a unified news feed and monitoring of the home lab.
- **AdGuard Home** for ad-blocking and privacy protection.
- **Personal Site** for hosting your personal website.
- **Ghostfolio** for wealth management.
- **AdventureLog** for a travel tracker and trip planner.
- **FreshRSS** for a news aggregator.

## ⚙️ Requirements

1. **Raspberry Pi OS Lite (64-bit)**: Ensure your Raspberry Pi is running the latest version.
2. **Ansible**: Install Ansible on your local machine.
3. **Cloudflare-managed domain**: Required for dynamic DNS updates and subdomain routing.
4. **Ethernet connection**: Use a wired connection for your Raspberry Pi for stable performance.

> [!Important]
> When flashing your SD card, enable SSH and select the `Use password authentication` option.

> [!Note]
> If you choose a custom hostname or user, remember to update the `inventory.ini` file accordingly.

## 🏁 Getting Started

1. **Clone the repository**:

   ```sh
   git clone [https://github.com/Nitestack/raspberry-pi-5.git](https://github.com/Nitestack/raspberry-pi-5.git) ~/raspberry-pi-5

2. **Install required Ansible Galaxy collections**:

    ```sh
    ansible-galaxy install -r requirements.yml
    ```

3. **Configure Your Server**: Follow the steps in the [Configuration](#%EF%B8%8F-configuration) section below to set up your variables.

4. **Run the playbook**:

    ```sh
    ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
    ```

> [!IMPORTANT]
> This only works if you have set up password-less SSH authentication on your Raspberry Pi. Please look at the [Security](#%EF%B8%8F-security) section for more details.

## 🛠️ Configuration

This project uses Ansible's best practices for variable management, separating public configuration from private secrets.

### 1. Public Configuration (`group_vars/all/main.yml`)

This file contains all non-sensitive configuration for your server, such as domain names, ports, and feature flags. Open `group_vars/all/main.yml` and customize the settings to match your environment.

**Key settings to change:**

- `domain`: Your root domain (e.g., "example.com").
- `data_base_dir`: The base path where all service data will be stored.
- `common_static_ip`: The static IP address for your Raspberry Pi.
- `services`: The dictionary where you can customize the domain and ports for each individual service.

### 2. Secret Management (`group_vars/all/vault.yml`)

All sensitive data (API keys, passwords, secrets) is stored in an encrypted Ansible Vault file.

**To set up your secrets:**

1. **Copy the example file:** Create your vault file by copying the provided template.

    ```sh
    cp vault.yml.example group_vars/all/vault.yml
    ```

2. **Fill in your secrets:** Open `group_vars/all/vault.yml` with your favorite text editor and fill in all the required secret values.

3. **Encrypt the file:** Once you have filled in your secrets, encrypt the file. You will be prompted to create a vault password. **Do not lose this password!**

    ```sh
    ansible-vault encrypt group_vars/all/vault.yml
    ```

4. **Edit the file later:** To edit the secrets file in the future, use:

    ```sh
    ansible-vault edit group_vars/all/vault.yml
    ```

## 🔌 Port Forwarding

To ensure remote access and proper functionality, configure the following port forwarding rules on your router. The playbook will automatically configure the server's firewall (UFW) based on these variables.

```plaintext
# Caddy (handling all websites and APIs)
public:80/tcp -> local:80/tcp
public:443/tcp -> local:443/tcp
public:443/udp -> local:443/udp

# WireGuard (value from 'wg_easy_udp_port' in main.yml)
public:{{ wg_easy_udp_port }}/udp -> local:{{ wg_easy_udp_port }}/udp

# SSH (optional, if you want to access the Pi with a URL)
public:22/tcp -> local:22/tcp
```

## 🛡️ Security

### 1. Add Your Host to Authorized Keys on the Raspberry Pi

To enable secure, password-less SSH access for Ansible, copy your public SSH key to the Raspberry Pi:

```sh
ssh-copy-id your_user@your_pi_ip_or_hostname
```

### 2. Update SSH Configuration

Edit the `/etc/ssh/sshd_config` file on the Raspberry Pi to disable password authentication and strengthen security. Update the following settings:

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
