#!/bin/bash

# Navigate to the directory where Jenkins copied the files
cd /home/ubuntu/app

echo "Starting Docker Deployment..."

# 1. Build the new Docker image from the Dockerfile
sudo docker build -t tic-tac-toe-app:latest .

# 2. Stop the running container (if it exists). 
# The '|| true' prevents the script from crashing if it's the first time running.
sudo docker stop game-container || true

# 3. Remove the old container
sudo docker rm game-container || true

# 4. Run the new container! 

sudo docker run -d --name game-container -p 80:80 tic-tac-toe-app:latest

echo "Deployment Complete! Container is running."
