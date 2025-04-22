# Quick Site Deployment

An automation script to help beginners quickly deploy HTTPS websites.

## Features

- 🚀 Automatic HTTPS certificate configuration
- 🔒 Automatic Nginx reverse proxy setup
- 🛡️ Automatic firewall rules configuration
- 📝 Automatic certificate renewal
- ⚡ HTTP/2 protocol support
- 🔄 Automatic backup of existing configurations

## Prerequisites

1. A domain name resolved to your server
2. Ubuntu/Debian system
3. Root privileges
4. Running backend service

## Usage

1. Clone the repository:
```bash
git clone https://github.com/ChuranNeko/quick-site-deployment.git
# or use Gitee
git clone https://gitee.com/ChuranNeko/quick-site-deployment.git
```

2. Enter the project directory:
```bash
cd quick-site-deployment
```

3. Run the script:
```bash
# Use English version script
sudo bash deploy_en.sh

# Use Chinese version script
sudo bash deploy.sh
```

> Note: Both scripts have identical functionality, they only differ in the language of prompts and comments. Choose the version that suits you best.

4. Enter the following information when prompted:
   - Your domain name
   - Your email address (for SSL certificate)
   - Your backend service port number

## Important Notes

1. Domain Configuration:
   - Ensure the domain is correctly resolved to your server IP
   - Supports subdomains

2. Port Configuration:
   - Default port is 7001
   - Can be modified according to actual needs
   - Ensure the port is not occupied by other services

3. SSL Certificate:
   - Automatically requests Let's Encrypt certificates
   - Configures automatic certificate renewal
   - Certificates are valid for 90 days
   - System will automatically renew before expiration

4. Security Notes:
   - Script automatically configures firewall
   - Only opens ports 80 and 443
   - Enables automatic HTTPS redirection

## Common Issues

1. If you encounter "This script must be run as root":
   - Run the script with sudo

2. If you encounter "No service listening on port":
   - Check if the backend service is running properly
   - Verify the port number is correct

3. If you encounter domain resolution errors:
   - Check if DNS resolution is correct
   - Wait for DNS propagation (usually takes a few minutes to hours)

## Technical Support

If you encounter any issues during usage, feel free to:
- Submit a [GitHub Issue](https://github.com/ChuranNeko/quick-site-deployment/issues)
- Submit a [Gitee Issue](https://gitee.com/ChuranNeko/quick-site-deployment/issues)

## License

This project is licensed under the [MIT License](../LICENSE) (includes both English and Chinese versions).

- ✅ Commercial use allowed
- ✅ Modification allowed
- ✅ Distribution allowed
- ✅ Private use allowed
- 📝 License notice required

This means you are free to use, modify, and distribute this project as long as you include the original license in your project. The license file contains complete descriptions in both English and Chinese.

## Script Details

The script performs the following operations:

1. Environment Check:
   - Verifies root privileges
   - Checks system compatibility
   - Validates domain resolution

2. Package Installation:
   - Nginx
   - Certbot
   - Required dependencies

3. Configuration:
   - Backs up existing Nginx configuration
   - Creates new Nginx configuration
   - Sets up SSL certificates
   - Configures firewall rules

4. Validation:
   - Tests Nginx configuration
   - Verifies SSL certificate installation
   - Checks automatic renewal setup

## Security Features

- Implements secure SSL/TLS configuration
- Enables HTTP/2 for better performance
- Configures secure headers
- Sets up automatic HTTPS redirection
- Implements recommended security practices