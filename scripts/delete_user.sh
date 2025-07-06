#!/bin/bash

if [[ "$EUID" -ne 0 && "$(groups $USER)" != "sudo" ]]; then
  echo "Only users with sudo privileges can run this script."
  exit 1
fi

read -p "Enter the username to delete: " username

if ! id "$username" &>/dev/null; then
  echo "User '$username' does not exist."
  exit 1
fi

read -p "Are you sure you want to delete user '$username' and all associated data? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Deletion cancelled."
  exit 0
fi

sudo userdel -r "$username"

user_dir="/home/file_sharing/users/$username"
if [ -d "$user_dir" ]; then
  sudo rm -rf "$user_dir"
  echo "Deleted $user_dir"
else
  echo "No personal folder found for $username."
fi

shared_user_dir="/home/file_sharing/shared/$username"
if [ -d "$shared_user_dir" ]; then
  sudo rm -rf "$shared_user_dir"
  echo "Deleted shared folder: $shared_user_dir"
else
  echo "No shared folder found for $username."
fi

echo "User '$username' and their data have been deleted successfully."

log_file="/home/file_sharing/logs.txt"
echo "[DELETED] User '$username' | Folder removed: $user_dir | Shared removed: $shared_user_dir | Time: $(date)" >> "$log_file"
