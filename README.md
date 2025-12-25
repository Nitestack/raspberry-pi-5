<div align="center">
<h1>
  🍓 Raspberry Pi 5
  <br/>
  Home Server
  <br/>
  <sup>
    <sub>Powered by <a href="https://ansible.com/" target="_blank">Ansible</a></sub>
  </sup>
</h1>

![Latest Commit](https://img.shields.io/github/last-commit/Nitestack/raspberry-pi-5?style=for-the-badge)
![GitHub Repo Stars](https://img.shields.io/github/stars/Nitestack/raspberry-pi-5?style=for-the-badge)
![Github Created At](https://img.shields.io/github/created-at/Nitestack/raspberry-pi-5?style=for-the-badge)

[Features](#-features) • [Requirements](#️-requirements) • [Getting Started](#-getting-started) • [Configuration](#-configuration) • [Security](#%EF%B8%8F-security) • [Backups](#-backups) • [License](#-license)

_This [Ansible](https://ansible.com) configuration automates the setup of a Home Server running [Raspberry Pi OS](https://raspberrypi.com/software). It deploys essential services using a modern, secure, and declarative best-practice architecture._

<p>
  <strong>If you find this repository useful, please <a href="#" title="star">⭐️</a> or fork it!</strong>
</p>
</div>

## 🚀 Features

### Core Infrastructure

- **fail2ban**: IP Address Banning
- **UFW**: Firewall Configuration
- **restic** & **rclone**: Backup Solution with Remote Support

### Docker Services

- **AdGuard Home**: Network-wide Ad Blocker
- **AdventureLog**: Travel Tracker
- **Beszel**: Server Monitoring
- **Caddy**: Reverse Proxy & TLS
- **Calibre Web Automated**: eBook Manager
- **Calibre Web Automated Book Downloader**: Book Downloader for Calibre Web
- **Ente Auth**: Two-factor Authenticator
- **FlareSolverr**: Proxy Server for bypassing Cloudflare protections
- **FreshRSS**: Feed Aggregator
- **Ghostfolio**: Wealth Manager
- **Glance**: Dashboard
- **Immich**: Image & Video Manager
- **Lidarr**: Music Manager
- **Navidrome**: Music Server
- **NextCloud**: Cloud
- **Pocket ID**: OIDC Provider
- **Prowlarr**: Indexer Manager
- **Real-Debrid Torrent Client**: Torrent Client
- **Vaultwarden**: Password Manager
- **wger Workout Manager**: Fitness Tracker
- **Yamtrack**: Media Tracker (TV Shows, TV Seasons, Movies, Anime, Manga, Games, Books, Comics)
- **Zerobyte**: Backup Manager (Web GUI for `restic`)

## ⚙️ Requirements

1. **Raspberry Pi OS Lite (64-bit)**: Ensure your Raspberry Pi is running the latest version.
2. **Ansible**: Install Ansible on your local machine.
3. **Cloudflare Account**: Required for dynamic DNS updates and subdomain routing. Sign up for a [Cloudflare account](https://dash.cloudflare.com/sign-up).
4. **Cloudflare Zero Trust**: Required for secure access via Cloudflare Tunnel. Create a [Zero Trust Organization](https://developers.cloudflare.com/cloudflare-one/setup/#create-a-zero-trust-organization).
5. **Ethernet connection**: Use a wired connection for your Raspberry Pi for stable performance.

> [!Important]
> When flashing your SD card, enable SSH and select the `Use password authentication` option.

> [!Note]
> If you choose a custom hostname or user, remember to update the `inventory.ini` file accordingly.

## 🏁 Getting Started

1. **Clone the repository**:

   ```sh
   git clone https://github.com/Nitestack/raspberry-pi-5.git ~/raspberry-pi-5

2. **Install required Ansible Galaxy collections**:

    ```sh
    ansible-galaxy install -r requirements.yml
    ```

3. **Configure Your Server**: Follow the steps in the [Configuration](#-configuration) section below to set up your variables.

4. **Run the playbook**:

    ```sh
    ansible-playbook deploy.yml
    ```

> [!IMPORTANT]
> This only works if you have set up password-less SSH authentication on your Raspberry Pi. Please look at the [Security](#%EF%B8%8F-security) section for more details.

## 🛠️ Configuration

### Cloudflare One

#### Cloudflare Tunnel - access your services publicly

Follow the guide [1. Connect the server to Cloudflare](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/private-net/cloudflared/connect-cidr/#1-connect-the-server-to-cloudflare) to create a [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel). This is a required step for accessing the services remotely.

> [!IMPORTANT]
> If you reach the **Install and run connectors** step, please just select installation with **Docker** and just copy the token and paste it into the Ansible vault (`cloudflared_token`). Please run the `cloudflare_tunnel` task with to connect to the tunnel:
>
> ```sh
> ansible-playbook deploy.yml --tags cloudflare_tunnel
> ```

#### Cloudflare WARP - connect to your home network remotely and securely

Follow the guide [Gateaway with WARP (default)](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/warp/set-up-warp/#gateway-with-warp-default) to successfully set up [Cloudflare WARP](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/warp) to remotely connect to your home network securely. You can skip step **4. Install the Cloudflare root certificate on your devices.**.

### Ansible Variables

#### 1. Public Configuration (`group_vars/all/main.yml`)

This file contains all non-sensitive configuration for your server, such as domain names, ports, and feature flags. Open `group_vars/all/main.yml` and customize the settings to match your environment.

#### 2. Secret Management (`group_vars/all/vault.yml`)

All sensitive data (API keys, passwords, secrets) is stored in an encrypted Ansible Vault file. For convenience, we will store the vault password in a local, git-ignored file.

**To set up your secrets:**

1. **Create your vault password file:** Create a file named `.vault_pass` in the project root containing only your vault password.

```sh
echo "YOUR_SUPER_SECRET_VAULT_PASSWORD" > .vault_pass
chmod 600 .vault_pass # Set restrictive file permissions (read/write for your user only)
```

2. **Create and fill your vault:** Copy the `vault.yml.example` file to `group_vars/all/vault.yml`, fill in your secrets, and then encrypt it. Ansible will automatically use your `.vault_pass` file.

```sh
cp vault.yml.example group_vars/all/vault.yml # copy template

# -- NOW, EDIT group_vars/all/vault.yml AND ADD YOUR SECRETS --

ansible-vault encrypt group_vars/all/vault.yml # encrypt file
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

## 💾 Backups

This setup includes an automated backup solution using **Restic** and **Rclone**.

- **Remote Backups**: Stored on OneDrive or Proton Drive

Backups are performed daily via a cron job and can also be triggered via the "Backup" GitHub Actions workflow.

### Configuration

1. **Install `rclone`** on your local machine.
2. **Configure `rclone`**: Run `rclone config` and follow the steps to set up a new remote.
3. **Update `vault.yml`**: Fill in your secrets (`rclone_...`). You can get the config by running `rclone config show <your_remote_name>`.

## 📝 License

This project is licensed under the Apache-2.0 license.
