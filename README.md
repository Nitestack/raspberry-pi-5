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

## ⚙️ Requirements

Make sure your Raspberry Pi is running the latest version of [Raspberry Pi OS Lite (64-bit)](https://www.raspberrypi.com/software).

You'll also need to install [Ansible](https://www.ansible.com) and `sshpass` on your local machine.

A domain is required to run Vaultwarden.

> [!IMPORTANT]
> When flashing your SD card, remember to enable SSH and select the `Use password authentication` option.

> [!IMPORTANT]
> If you plan to customize the default user or hostname, update these details accordingly in the `inventory.ini` file.

> [!NOTE]
> To ensure `.local` domain resolution works properly, you must have Avahi installed and running. If Avahi isn't set up, you can connect using the Raspberry Pi's IPv4 address directly.

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

### Vaultwarden

To get Vaultwarden running, you’ll need to configure port forwarding on your router:

```
public:8080/tcp -> local:80/tcp
public:443/tcp  -> local:443/tcp
public:443/udp  -> local:443/udp
```

> [!NOTE]
> If you modify any ports in the `docker-compose.yml`, make sure to update your port forwarding settings accordingly.

## 📝 License

This project is licensed under the Apache-2.0 license.
