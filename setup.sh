#!/bin/bash

# Styling functions for better terminal output
print_header() {
    echo -e "\033[1;34m$1\033[0m"
}

print_success() {
    echo -e "\033[1;32m$1\033[0m"
}

print_warning() {
    echo -e "\033[1;33m$1\033[0m"
}

print_step() {
    echo -e "\033[1;36m$1\033[0m"
}

pause_for_user() {
    echo
    print_step "Press Enter to continue..."
    read -r
}

print_header "Starting Nillion Verifier Setup Script"

# Step 1: Update and install dependencies
print_step "Step 1: Updating system and installing dependencies"
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Step 2: Add Docker’s official GPG key
print_step "Step 2: Adding Docker’s official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Step 3: Add Docker repository to Apt sources
print_step "Step 3: Adding Docker repository to Apt sources"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Step 4: Install Docker and required packages
print_step "Step 4: Installing Docker and its components"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 5: Check Docker installation
print_step "Step 5: Checking Docker installation"
docker container run --rm hello-world
if [ $? -eq 0 ]; then
    print_success "Docker is installed and working properly."
else
    print_warning "There was an issue with Docker installation."
    exit 1
fi

pause_for_user

# Step 6: Pull Nillion Verifier image
print_step "Step 6: Pulling the Nillion Verifier image"
docker pull nillion/verifier:v1.0.1

# Step 7: Initialize the verifier
print_step "Step 7: Initializing the Nillion Verifier"
mkdir -p nillion/verifier
docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise

# Extracting Verifier Account ID and Public Key from the output
output=$(docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise)

account_id=$(echo "$output" | grep -i "Verifier account id" | awk -F": " '{print $2}')
public_key=$(echo "$output" | grep -i "Verifier public key" | awk -F": " '{print $2}')

print_success "Verifier Account ID: $account_id"
print_success "Verifier Public Key: $public_key"

print_warning "Please add at least 0.005 NIL to the account ID ($account_id) via your Keplr wallet."

# Step 8: Instructions for website registration
print_step "Step 8: Proceed with verifier registration"
echo -e "Now go to \033[4;34mhttps://verifier.nillion.com/verifier\033[0m"
echo "Follow these steps:"
echo "1. Click on Linux."
echo "2. Go to step 5."
echo "3. Enter your Account ID: $account_id and Public Key: $public_key."
echo "4. Connect with your Keplr wallet and register your verifier."

read -p "Once completed, type 'yes' to continue: " completed
if [[ "$completed" != "yes" && "$completed" != "y" ]]; then
    print_warning "Please complete the registration to proceed."
    exit 1
fi

pause_for_user

# Step 9: Run the verifier
print_step "Step 9: Running the Nillion Verifier in detached mode"
docker run -d --name nillion -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"

# Give the verifier a few seconds to start and generate initial logs
sleep 5

# Step 9: Check if a container named 'nillion' already exists
if [ $(docker ps -aq -f name=nillion) ]; then
    print_warning "A container named 'nillion' already exists. Removing it..."
    docker rm -f nillion
    print_success "Existing 'nillion' container removed."
fi

# Step 9: Run the verifier
print_step "Step 9: Running the Nillion Verifier in detached mode"
docker run -d --name nillion -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"

# Give the verifier a few seconds to start and generate initial logs
sleep 5

# Step 9.1: Checking if the account is funded
print_step "Checking if the verifier's account is funded..."
log_output=$(docker logs nillion 2>&1)

# Check for the specific warning and error messages in the logs
if echo "$log_output" | grep -q "Is your verifier's account funded" && echo "$log_output" | grep -q "Failed to initialise nillion client"; then
    print_warning "ERROR: Your verifier's account is not funded!"
    echo -e "\033[1;31mPlease fund the account ID with at least 0.005 NIL from your Keplr wallet and try again.\033[0m"
    
    read -p "Once you have funded the account, press Enter to continue..."
    
    # Re-run the verifier after the user has funded the account
    print_step "Re-running the Nillion Verifier in detached mode"
    docker restart nillion
    
    # Wait a few seconds and check the logs again
    sleep 5
    docker logs nillion
else
    print_success "Verifier is running successfully!"
fi

# Step 10: Backup credentials
print_step "Step 10: Backing up your credentials"
mkdir -p nillion-backup
cp ./nillion/verifier/credentials.json ./nillion-backup
print_success "Credentials backup completed at: ./nillion-backup"

pause_for_user

# Step 11: Final instructions
print_step "Final Steps:"
echo "Check back in 10 minutes to see if your node is synced."
echo -e "To view logs, run: \033[1;32mdocker logs -f nillion\033[0m"

print_success "Nillion Verifier setup completed successfully!"
