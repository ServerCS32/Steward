
# Steward

Steward is a tool designed to help you host your own server without the need for a static or public IP address. It enhances server security by masking your IP address and tunnels all data through Cloudflare's servers.

## Features

- Host your own server without requiring a static or public IP address.
- Enhanced server security by masking your IP address.
- Data tunneling through Cloudflare's servers for additional protection.

## Prerequisites

Before setting up Steward, ensure the following:

- You have a domain name pointed towards Cloudflare's DNS nameservers.
- You have sudo access on your system.

## Installation

To install Steward, follow these steps:

1. Give executable permission to the scripts by running the following command:
    ```bash
    sudo chmod +x setup.sh steward.sh
    ```

2. Run the setup script to install the program:
    ```bash
    sudo ./setup.sh
    ```

    During the installation process, you will be prompted to log in to your Cloudflare account. This is required for automatic setup.

    ![Alt text](/lib/images/image.png)

## Usage

Once Steward is installed, you can start it by running the following command:

```bash
sudo steward
```

This command will start the Steward service, and your server will be up and running.

![Alt text](/lib/images/image2.png)

## Contributing

Contributions to Steward are welcome! If you want to contribute, please follow these guidelines:

1. Fork the repository.
2. Create a new branch for your feature or bug fix (`git checkout -b feature/branch-name`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature/branch-name`).
6. Create a new Pull Request.

## License

This project is licensed under the [MIT License](LICENSE), making it an open-source project.

---

Feel free to adjust the license or any other part of the README to better fit your project's needs. Let me know if you need further assistance!#
