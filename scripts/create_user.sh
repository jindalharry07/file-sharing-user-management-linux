#!/bin/bash

if [[ "$EUID" -ne 0 && "$(groups $USER)" != "sudo" ]]; then
  echo "Only users with sudo privileges can run this script."
  exit 1
fi

read -p "Enter new username: " username

if id "$username" &>/dev/null; then
  echo "User '$username' already exists!"
  exit 1
fi

sudo useradd -m "$username"

echo "Set password for $username:"
sudo passwd "$username"

sudo usermod -aG sharedgroup "$username"

user_dir="/home/file_sharing/users/$username"
sudo mkdir -p "$user_dir"
sudo chown "$username:$username" "$user_dir"
sudo chmod 700 "$user_dir"

# Create user's shared folder
shared_user_dir="/home/file_sharing/shared/$username"
sudo mkdir -p "$shared_user_dir"
sudo chown "$username:sharedgroup" "$shared_user_dir"
sudo chmod 750 "$shared_user_dir"

echo "User '$username' created successfully."
echo "Private folder: $user_dir"
echo "Shared folder: $shared_user_dir"
echo "Added to group: sharedgroup"

log_file="/home/file_sharing/logs.txt"
echo "[CREATED] User '$username' | Folder: $user_dir | Shared: $shared_user_dir | Time: $(date)" >> "$log_file"
