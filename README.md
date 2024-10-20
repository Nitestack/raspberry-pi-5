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

_This [Ansible](https://www.ansible.com) configuration is designed to automate the setup and management of a Raspberry Pi Home Server running [Raspberry Pi OS](https://www.raspberrypi.com/software). The configuration aims to streamline the deployment of various services, enhance security, and ensure consistency across the server environment._

<p>
  <strong>Be sure to <a href="#" title="star">⭐️</a> or fork this repo if you find it useful!</strong>
</p>
</div>

## 🚀 Features

> [!WARNING]
> This setup will only work if your domain is fully managed by Cloudflare DNS.

- Caddy and Docker Installation

- Vaultwarden Setup

- Cloudflare DDNS Updater Setup (for dynamic IPv4 addresses)

- PiVPN (Wireguard) Setup

## ⚙️ Requirements

Make sure your Raspberry Pi is running the latest version of [Raspberry Pi OS Lite (64-bit)](https://www.raspberrypi.com/software).

You'll also need to install [Ansible](https://www.ansible.com) and `sshpass` on your local machine.

A domain is required.

Your Raspberry Pi has to be connected via ethernet cable.

> [!IMPORTANT]
> When flashing your SD card, remember to enable SSH and select the `Use password authentication` option.

> [!IMPORTANT]
> If you plan to customize the default user or hostname, update these details accordingly in the `inventory.ini` file.

> [!NOTE]
> To ensure `.local` domain resolution works properly, you must have Avahi installed and running. If Avahi isn't set up, you can connect using the Raspberry Pi's IPv4 address directly.

Also ensure you Raspberry Pi has an internal static IPv4 address. You can run the following commands to bind the Pi to `192.168.2.210`:

```sh
sudo nmcli con mod "Wired connection 1" ipv4.addresses "192.168.2.210/24" \
  ipv4.gateway "192.168.2.1" \
  ipv4.dns "192.168.2.1" \
  ipv4.method manual && \
sudo nmcli con up "Wired connection 1"
```

This has to be done once to register the device in the network. After executing the Ansible playbook the first time, it ensures the configuration stays.

## 🏁 Getting Started

Clone the dotfiles repository:

```sh
git clone https://github.com/Nitestack/raspberry-pi-5.git ~/raspberry-pi-5
```

Install Ansible Galaxy Collections:

```sh
ansible-galaxy install -r requirements.yml --force # to get the latest versions
```

Finally run the playbook:

```sh
ansible-playbook -i inventory.ini playbook.yml --ask-pass
```

This will prompt you for the password for the user on the Raspberry Pi.

### Environment Variables

Ensure you create a `secrets.yml` file in the root directory of this project. Just copy the `secrets.example.yml` file to `secrets.yml` and insert the values.

### Cloudflare DDNS Updater

Make sure to create an `A` record for your domain that initially points to a placeholder IP address (e.g., `8.8.8.8`). This will be automatically updated to your public IP address by the script. Specify the record name in the `secrets.yml` file under the key `CLOUDFLARE_RECORD_NAME`.

### PiVPN

Create a `CNAME` record for your domain that directs your PiVPN subdomain to the value specified in `CLOUDFLARE_RECORD_NAME`. Furthermore, set the domain in the `PIVPN_HOST` variable.

You'll also need to configure port forwarding on your router:

```
public:51820/tcp -> local:51820/tcp
```

### Vaultwarden

To get Vaultwarden running, you’ll need to configure port forwarding on your router:

```
public:8080/tcp -> local:80/tcp
public:443/tcp  -> local:443/tcp
public:443/udp  -> local:443/udp
```

> [!NOTE]
> If you modify any ports in the `docker-compose.yml`, make sure to update your port forwarding settings accordingly.

Create a `CNAME` record for your domain that points your Vaultwarden subdomain to the value specified in `CLOUDFLARE_RECORD_NAME`. Additionally, set the full URL (including the `https://`` prefix) in the`VAULTWARDEN_DOMAIN` variable.

## 📝 License

This project is licensed under the Apache-2.0 license.
