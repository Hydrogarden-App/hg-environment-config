#!/bin/bash

# Enable UFW and set defaults
sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH from outside
sudo ufw allow 22/tcp

# Allow RabbitMQ and MQTT ports from outside
sudo ufw allow 5672/tcp    # RabbitMQ AMQP
sudo ufw allow 1883/tcp    # MQTT
sudo ufw allow 15672/tcp   # RabbitMQ management (optional)

# Allow all traffic on VPN interface (tun0)
sudo ufw allow in on tun0
sudo ufw allow out on tun0

# Reload to apply
sudo ufw reload

# Show status
sudo ufw status verbose
