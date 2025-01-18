# Docker Registry

This repository provides the necessary files and instructions to set up a secure Docker registry with SSL encryption and basic authentication.

## Prerequisites
Ensure you have the following tools installed:
- Docker
- Docker Compose

## Setup

Follow these steps to generate the necessary SSL certificates and authentication files:

### 1. Make the setup script executable:
```bash
chmod +x setup.sh
```

### 2. Run the setup script:
```bash
./setup.sh
```

This script will:
- Create the `auth` directory and generate the `htpasswd` file using the provided username and password.
- Create the `certificates` directory and generate the SSL certificates (`registry.key` and `registry.crt`).

**Note:** Be sure to replace `<username>` and `<password>` in the script with your desired credentials.


### Handling Certificate Errors
If you're not using your own SSL certificate, Cloudflare provides a free SSL certificate for your domain. You can use it to secure your registry and prevent certificate errors. Make sure to set the SSL/TLS encryption mode to **Full** on Cloudflare for proper security.

For the example, you can refer to the [example](./example) folder.