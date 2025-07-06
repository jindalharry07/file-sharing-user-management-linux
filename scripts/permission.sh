#!/bin/bash

# Set permissions for main shared folder
shared_folder="/home/file_sharing/shared"
if [ -d "$shared_folder" ]; then
  sudo chgrp sharedgroup "$shared_folder"
  sudo chmod 770 "$shared_folder"
  echo "Shared folder permissions set (770, group: sharedgroup)"
else
  echo "Shared folder not found!"
fi

# Set permissions for personal folders in users directory
users_base="/home/file_sharing/users"
if [ -d "$users_base" ]; then
  for user_dir in "$users_base"/*; do
    if [ -d "$user_dir" ]; then
      username=$(basename "$user_dir")
      sudo chown "$username:$username" "$user_dir"
      sudo chmod 700 "$user_dir"
      echo "Set 700 permission for $user_dir (owner: $username)"
    fi
  done
else
  echo "Users folder not found!"
fi

# Set permissions for personal folders inside shared directory
if [ -d "$shared_folder" ]; then
  for user_shared in "$shared_folder"/*; do
    if [ -d "$user_shared" ]; then
      username=$(basename "$user_shared")
      if id "$username" &>/dev/null; then
        sudo chown "$username:sharedgroup" "$user_shared"
        sudo chmod 750 "$user_shared"
        echo "Set 750 permission for $user_shared (owner: $username, group: sharedgroup)"
      fi
    fi
  done
fi
