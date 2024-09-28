Sure! Here's a detailed and well-structured `README.md` for your GitHub repository that will guide users on how to use your `setup.sh` script to set up their Nillion Verifier Node, including the steps to visit the website and manage the verifier node.

---

# Nillion Verifier Node Setup

This repository contains an automated shell script (`setup.sh`) that helps you set up your Nillion Verifier Node effortlessly on an Ubuntu machine.

## Prerequisites

Before running the script, ensure that:

1. You are using **Ubuntu**.
2. You have **sudo** privileges on your machine.

## How to Use the Script

Follow these steps to set up your Nillion Verifier Node:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/nillion-verifier-setup.git
cd nillion-verifier-setup
```

### 2. Make the Script Executable

Before you run the script, you need to make it executable. Run:

```bash
chmod +x setup.sh
```

### 3. Run the Setup Script

Now run the setup script to install Docker, set up the Nillion Verifier Node, and follow through the process. The script will guide you through each step.

```bash
./setup.sh
```

### 4. Follow the Script's Instructions

The script will guide you step by step through:

- Installing Docker and its dependencies.
- Initializing your Nillion Verifier.
- Showing your **Verifier Account ID** and **Public Key**.

Once the initialization is complete, you'll be prompted to proceed with the following steps.

## Verifier Registration on the Nillion Website

After the initialization step, you need to complete your verifier registration on the Nillion Verifier website. Here’s how to do it:

1. **Go to the Nillion Verifier Website**:
   [https://verifier.nillion.com/verifier](https://verifier.nillion.com/verifier)

2. **Follow these steps**:
   - Select **Linux** as your operating system.
   - Proceed to **Step 5** of the registration instructions.
   - Enter your **Verifier Account ID** and **Verifier Public Key** (displayed by the script during initialization).
   - Connect your **Keplr wallet** to the website.
   - Register your verifier.
   - **Sign** the transaction from the wallet you want to tie with this verifier.

3. **Fund Your Verifier Account**:
   - Add at least **0.005 NIL** to the **Verifier Account ID** using your Keplr wallet.

4. Once you’ve completed the registration on the website, return to the terminal and type `yes` to continue with the setup.

## Viewing Your Verifier Logs

After the registration is done and the node is set up, you can view the logs of your verifier node to monitor its status:

### View Logs in Real Time

To check the verifier logs in real-time, run the following command:

```bash
docker logs -f nillion
```

### Checking Node Sync

Once the verifier is up and running, it may take some time for your node to sync with the network. You can check the logs after 10 minutes to ensure everything is running correctly.

---

## Backing Up Your Credentials

During the setup, your `credentials.json` file (which contains important information about your verifier) is automatically backed up. You can find the backup in the following directory:

```bash
~/nillion-backup/credentials.json
```

Make sure to keep this file safe!

---

## Troubleshooting

### Docker Not Running?

If Docker fails to run or install properly, try manually verifying the installation by running:

```bash
docker --version
```

Ensure Docker is running by starting the Docker service:

```bash
sudo systemctl start docker
```

### Missing Funds?

Ensure you have added **at least 0.005 NIL** to your Verifier Account ID before proceeding with the registration. You can add these funds using the **Keplr wallet**.

---

## Next Steps

Once the node is running, you can continue to monitor your verifier by periodically checking the logs, backing up your credentials, and ensuring the node remains synced with the network.

If you have questions or run into issues, feel free to open an issue on the repository or reach out to the Nillion community for support.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contributing

Feel free to submit pull requests, open issues, or suggest improvements! All contributions are welcome.

---

## Acknowledgements

Special thanks to the Nillion team for providing the verifier image and documentation to make this possible.

---

By following the above steps, you can quickly set up and manage your Nillion Verifier Node. Let us know if you encounter any issues, and happy verifying!

---
