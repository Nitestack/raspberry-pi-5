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

![Latest commit](https://img.shields.io/github/last-commit/Nitestack/raspberry-pi-5?style=for-the-badge)
![GitHub Repo stars](https://img.shields.io/github/stars/Nitestack/raspberry-pi-5?style=for-the-badge)
![Github Created At](https://img.shields.io/github/created-at/Nitestack/raspberry-pi-5?style=for-the-badge)

[Features](#-features) • [Requirements](#️-requirements) • [Getting Started](#-getting-started) • [License](#-license)

_This [Ansible](https://www.ansible.com) configuration automates the setup of a Raspberry Pi Home Server running [Raspberry Pi OS](https://www.raspberrypi.com/software). It deploys essential services, enhances security, and ensures consistency across the server environment._

<p>
  <strong>Be sure to <a href="#" title="star">⭐️</a> or fork this repo if you find it useful!</strong>
</p>
</div>

## 🚀 Features

> [!WARNING]
> This setup requires your domain to be fully managed by Cloudflare DNS.

- Automated installation of Docker
- Vaultwarden deployment
- Cloudflare DDNS updater for dynamic IP management
- PiVPN (WireGuard) configuration for secure remote access
- NextCloud

## ⚙️ Requirements

1. **Raspberry Pi OS Lite (64-bit)**: Ensure your Raspberry Pi is running the latest version.
2. **Ansible and sshpass**: Install these tools on your local machine.
3. **Cloudflare-managed domain**: Necessary for dynamic DNS updates and subdomain routing.
4. **Ethernet connection**: Your Raspberry Pi must be connected via Ethernet for optimal stability.

> [!IMPORTANT]
> When flashing your SD card, enable SSH and select the `Use password authentication` option.

> [!NOTE]
> If customizing your hostname or user, update the `inventory.ini` file accordingly.

5. **Static IPv4 configuration**: Your Raspberry Pi should have a static IP address on your local network. To assign the IP `192.168.2.210`, run the following:

```sh
sudo nmcli con mod "Wired connection 1" ipv4.addresses "192.168.2.210/24" \
  ipv4.gateway "192.168.2.1" \
  ipv4.dns "192.168.2.1" \
  ipv4.method manual && \
sudo nmcli con up "Wired connection 1"
```

This step is needed only once. The Ansible playbook will manage IP persistence thereafter.

> [!NOTE]
> Ensure Avahi is installed and running for `.local` domain resolution. Alternatively, use the Pi's IP address directly.

## 🏁 Getting Started

1. **Clone the repository**:

```sh
git clone https://github.com/Nitestack/raspberry-pi-5.git ~/raspberry-pi-5
```

2. **Install required Ansible Galaxy collections**:

```sh
ansible-galaxy install -r requirements.yml --force # to get the latest versions
```

3. **Run the playbook**:

```sh
ansible-playbook -i inventory.ini playbook.yml --ask-pass
```

This command prompts for the Raspberry Pi user's password.

### Environment Variables

To configure sensitive data, create a `secrets.yml` file in the root directory. Copy the `secrets.example.yml` file, then populate the required fields.

### Cloudflare DDNS Updater

Ensure an `A` record for your domain is set up, initially pointing to a placeholder IP (e.g., `8.8.8.8`). The DDNS script will update it with your public IP. The record name should be defined in `secrets.yml` under the key `CLOUDFLARE_RECORD_NAME`.

### PiVPN

Set up a `CNAME` record for your PiVPN subdomain, pointing it to the value defined in `CLOUDFLARE_RECORD_NAME`. Update the `PIVPN_DOMAIN` variable with the correct domain.

Configure port forwarding on your router for WireGuard:

```
public:51820/tcp -> local:51820/tcp
```

### Vaultwarden

Vaultwarden requires additional port forwarding:

```
public:8888/tcp -> local:80/tcp
public:443/tcp  -> local:443/tcp
public:443/udp  -> local:443/udp
```

> [!NOTE]
> If you modify ports in the `docker-compose.yml`, ensure your router’s port forwarding is adjusted accordingly.

Set up a `CNAME` record for your Vaultwarden subdomain, directing it to the value specified in `CLOUDFLARE_RECORD_NAME`. Also, set the `VAULTWARDEN_URL` variable to the URL.

### NextCloud

NextCloud requires additional port forwarding:

```
public:80/tcp  -> local:80/tcp
public:443/tcp -> local:443/tcp
public:443/udp -> local:443/udp
```

Set up a CNAME record for your NextCloud subdomain, directing it to the value specified in `CLOUDFLARE_RECORD_NAME`. Also, set the `NEXTCLOUD_URL` variable to the URL.

## 📝 License

This project is licensed under the Apache-2.0 license.
