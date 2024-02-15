#!/usr/bin/env bash
# Automated bootstrap script for devxp-linux.

# Define text color variables
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NC=$(tput sgr0) # No Color


# Navigate to the directory containing the script
cd "$(dirname "$0")" || exit

# Perform a git pull to update the repository
git pull

# Read the user from the file
USER=$(cat /usr/local/bin/devxp-files/user)

# Ensure that user has ownership of the devxp-files directory and its sub directories
sudo chown -R $USER /usr/local/bin/devxp-files
sudo chmod -R u+rx /usr/local/bin/devxp-files

# Upgrade the distro.
sudo apt-get update
sudo apt-get -y dist-upgrade

# Install tools.
sudo apt-get install -y make git python3 python3-pip

# Install Ansible via pip.
sudo apt-get remove -y ansible
sudo apt-get autoremove -y
python3 -m pip install --user ansible

# Give execute permission to user
sudo chmod -R +x /usr/local/bin/devxp-files/devxp-linux

# Ansible should now be installed in ~/.local/bin.
# If this directory did not exist already, then you might have to restart WSL.
# ~/.local/bin is conditionally loaded into $PATH in ~/.profile.

# Ensure that ~/.local/bin is loaded into $PATH.
source ~/.profile

# Run Ansible-runbooks to install necessary command-line tools.
ansible-galaxy install -r requirements.yml --force # pulls down necessary dependencies for Ansible.

logFile="/usr/local/bin/devxp-files/ansible-playbook.log"
lastRunFile="/usr/local/bin/devxp-files/lastRun"
reminderFile="/usr/local/bin/devxp-files/reminder"

# Write a message indicating that the Ansible playbook is starting
echo "${YELLOW}Ansible playbook is starting, this can take some time.${NC}"

# Run Ansible playbook and redirect output to the log file
if ansible-playbook site.yml --ask-become-pass > "$logFile" 2>&1; then

    # Completion message content
    content="devxp-linux was last ran $(date +'%d.%m.%y %H:%M')"

    # Write completion message
    echo "$content" | tee "$lastRunFile" > /dev/null

    # Write success message
    echo "${GREEN}Ansible playbook finished successfully.${NC}"
else
    # Write failure message
    echo "${RED}Ansible playbook execution failed. Please check $logFile for details.${NC}"

    # Completion message content
    content="devxp-linux failed it last run at $(date +'%d.%m.%y %H:%M') Please check $logFile for details."

    # Write completion message
    echo "$content" | tee "$lastRunFile" > /dev/null
    echo "false" > "$reminderFile"
    chmod a+rw "$reminderFile"
fi

echo "false" > "$reminderFile"
chmod a+rw "$reminderFile"
