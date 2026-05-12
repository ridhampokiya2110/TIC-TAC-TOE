#!/bin/bash
# 1. Update and Install Nginx
sudo apt-get update -y
sudo apt-get install nginx -y

# 2. Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 3. Cleanup existing files in Web Root
sudo rm -rf /var/www/html/*

# 4. Copy your repo files to Nginx folder
# Jenkins pipeline repo ko 'workspace' me clone karta hai
# Hum wahan se files move karenge
sudo cp -r /home/ubuntu/workspace/* /var/www/html/

# 5. Fix permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

echo "Tic-Tac-Toe App Deployed Successfully!"
