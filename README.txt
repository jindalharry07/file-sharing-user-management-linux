FILE SHARING AND USER MANAGEMENT SYSTEM (LINUX)

-----------------------------------------------
PROJECT OVERVIEW:
-----------------------------------------------

This system allows a root or sudo user to create and manage other users in a secure Linux file-sharing environment. Each user gets:

- A private folder under: /home/file_sharing/users/<username>
- A shared folder under: /home/file_sharing/shared/<username>

Users can:
- Read other users' files in shared/
- Write only into their own shared folder
- Have isolated personal folders
- Automatically have their data removed upon deletion

All actions (create/delete) are logged in: /home/file_sharing/logs.txt

-----------------------------------------------
FOLDER STRUCTURE:
-----------------------------------------------

/home/file_sharing/
├── users/        → Private directories (only user has access)
├── shared/       → Shared area where users can read others' files
├── scripts/      → Contains shell scripts for managing users
└── logs.txt      → Log file storing user activity (creation/deletion)

-----------------------------------------------
SCRIPTS INCLUDED:
-----------------------------------------------

1. create_user.sh
   - Usage: sudo ./create_user.sh
   - Prompts for username
   - Creates the user with home directory
   - Adds user to 'sharedgroup'
   - Creates:
       - /home/file_sharing/users/<username> (chmod 700)
       - /home/file_sharing/shared/<username> (chmod 750, owned by user:sharedgroup)
   - Logs creation info into logs.txt

2. delete_user.sh
   - Usage: sudo ./delete_user.sh
   - Prompts for username
   - Deletes:
       - The user account (kills active processes if necessary)
       - Their personal folder from users/
       - Their shared folder from shared/
   - Logs deletion info into logs.txt

3. permission.sh
   - Usage: sudo ./permission.sh
   - Sets/reset correct permissions for:
       - shared/ (chmod 770, group: sharedgroup)
       - users/<username> (chmod 700)
       - shared/<username> (chmod 750)
   - Useful to rerun if ownership or permissions get altered

-----------------------------------------------
GROUP CONFIGURATION:
-----------------------------------------------

- A group called 'sharedgroup' is used to manage shared folder access.
- All new users are added to this group.
- Only root or sudo users can execute these scripts.

Create the group (only once):
$ sudo groupadd sharedgroup

-----------------------------------------------
SETUP INSTRUCTIONS:
-----------------------------------------------

1. Create base folders:
$ sudo mkdir -p /home/file_sharing/{users,shared,scripts}

2. Copy all scripts into: /home/file_sharing/scripts/

3. Make scripts executable:
$ sudo chmod +x /home/file_sharing/scripts/*.sh

4. Create log file:
$ sudo touch /home/file_sharing/logs.txt
$ sudo chmod 644 /home/file_sharing/logs.txt

5. Run the permission script to initialize permissions:
$ sudo ./permission.sh

-----------------------------------------------
USAGE EXAMPLES:
-----------------------------------------------

- Create a user:
$ sudo ./create_user.sh

- Delete a user:
$ sudo ./delete_user.sh

- Reset permissions:
$ sudo ./permission.sh

-----------------------------------------------
LOGGING:
-----------------------------------------------

- All actions are logged in logs.txt in the format:
  [CREATED] User 'hello' | Folder: ... | Time: ...
  [DELETED] User 'hello' | Folder removed: ... | Time: ...

-----------------------------------------------
NOTES:
-----------------------------------------------

- The shared folder allows every user to read other users' files.
- Only the owner of their subfolder in shared/ can write or modify their files.
- Private folders are completely isolated (chmod 700).
- Make sure to run permission.sh after adding folders manually.

-----------------------------------------------
AUTHOR: Harry Jindal
UNIVERSITY PROJECT: File Management using Linux & Bash Scripting
