#!/bin/bash
# Server Setup Script for TickOff Test Environment
# Server: 2025hs-sbu142147-stud-gibb-ch
# IP: 49.13.165.123

set -e

echo "================================================"
echo "TickOff Test Environment - Server Setup"
echo "================================================"

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install essential tools
echo "🔧 Installing essential tools..."
sudo apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    build-essential

# Install Flutter SDK
echo "🐦 Installing Flutter SDK..."
if [ ! -d "$HOME/flutter" ]; then
    cd ~
    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.3-stable.tar.xz
    tar xf flutter_linux_3.35.3-stable.tar.xz
    rm flutter_linux_3.35.3-stable.tar.xz
    
    # Add Flutter to PATH
    echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    export PATH="$PATH:$HOME/flutter/bin"
    
    flutter doctor
else
    echo "✅ Flutter already installed"
fi

# Install Node.js and npm (for Firebase CLI)
echo "📦 Installing Node.js and npm..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "✅ Node.js already installed"
fi

# Install Firebase CLI
echo "🔥 Installing Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    sudo npm install -g firebase-tools
else
    echo "✅ Firebase CLI already installed"
fi

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo apt-get install -y \
        ca-certificates \
        gnupg \
        lsb-release
    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker $USER
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose
echo "🐙 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt-get install -y docker-compose
else
    echo "✅ Docker Compose already installed"
fi

# Install Nginx
echo "🌐 Installing Nginx..."
if ! command -v nginx &> /dev/null; then
    sudo apt-get install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
else
    echo "✅ Nginx already installed"
fi

# Create project directory
echo "📁 Creating project directory..."
mkdir -p ~/tickoff-test
cd ~/tickoff-test

# Clone repository (if not already cloned)
if [ ! -d "Tickoff" ]; then
    echo "📥 Cloning repository..."
    git clone https://github.com/DeadEndshadow/Tickoff.git
else
    echo "✅ Repository already cloned"
fi

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
cd ~/tickoff-test/Tickoff/tickoff
flutter pub get

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 9099/tcp  # Firebase Emulator
sudo ufw allow 8080/tcp  # Mock API Server
sudo ufw --force enable

echo "================================================"
echo "✅ Server setup completed successfully!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Start Firebase emulator: firebase emulators:start"
echo "2. Start Docker containers: docker-compose up -d"
echo "3. Run tests: flutter test"
echo ""
echo "⚠️  Note: You may need to log out and back in for Docker group changes to take effect"
