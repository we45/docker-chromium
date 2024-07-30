#!/bin/bash

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    printf "Docker is already installed.\n"
else
    printf "Docker is not installed. Installing Docker...\n"

    # Install Docker
    echo "Installing docker"
    # Add Docker's official GPG key:
    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq update -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq update -y

    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Verify Docker installation
if ! command -v docker &> /dev/null; then
    printf "Docker installation failed.\n"
fi

# Pull the correct version of chromium-vnc from our docker hub
printf "Pulling docker chromium-vnc image\n"
sudo docker pull appsecengineer/kasmvnc:https

# Parse named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -uname) uname="$2"; shift ;;
        -pwd) pwd="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Check if both names are provided
if [ -n "$uname" ] && [ -n "$pwd" ]; then
    printf "\nStarting browser with basic authentication\n"
    # Running docker with authn
    sudo docker run -d -p 8443:3001 \
    -e CUSTOM_USER=$USERNAME \
    -e PASSWORD=$PASSWORD \
    appsecengineer/kasmvnc:https
elif [ -z "$uname" ] && [ -z "$pwd" ]; then
    printf "\nStarting without authentication\n"
    printf "To use authentication, run the script with\n"
    printf "./chromium-vnc.sh -uname <username> -pwd <password>\n"
    # Running without authn
    sudo docker run -d -p 8443:3001 appsecengineer/kasmvnc:https
    sudo docker ps
else
    echo "Usage: $0 -uname <username> -pwd <password> or $0 (with no arguments)"
fi

# Providing browser access url
printf "\nThe browser can now be accessed at:\t\n"
echo https://$(jq -r '.apps.http.servers.srv0.routes[0].match[0].host[0]' /root/.config/caddy.json):8443
