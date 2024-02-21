#!/bin/bash

# Script to append a line to shell initialization files

script_to_trigger="/usr/local/bin/devxp-files/devxp-linux/scripts/rc-notifications.sh"

# Function to add or edit the line in the initialization file
add_or_edit_line() {
    local file="$1"
    local line_to_add="$2"
    local found=false

    # Check if the line already exists in the file
    if ! grep -Fxq "$line_to_add" "$file"; then
        echo "Line does not exist in $file. Adding the line."
        # Append the line to the file
        printf "%s\n" "$line_to_add" >> "$file"
        found=true
    fi
}

# Add or edit the line in .bashrc if Bash shell is being used
if [ -n "$BASH_VERSION" ]; then
    add_or_edit_line "$HOME/.bashrc" "$script_to_trigger"
fi

# Add or edit the line in .zshrc if Zsh shell is being used
if [ -n "$ZSH_VERSION" ]; then
    add_or_edit_line "$HOME/.zshrc" "$script_to_trigger"
fi

# Fish
if command -v fish &> /dev/null; then
    add_or_edit_line "$HOME/.config/fish/config.fish" "$script_to_trigger"
fi

# Ksh
if [ -n "$KSH_VERSION" ]; then
    add_or_edit_line "$HOME/.kshrc" "$script_to_trigger"
fi

# Dash
if [ -n "$DASH_VERSION" ]; then
    add_or_edit_line "$HOME/.dashrc" "$script_to_trigger"
fi

# Csh
if [ -n "$CSH_VERSION" ]; then
    add_or_edit_line "$HOME/.cshrc" "$script_to_trigger"
fi

# Tcsh
if [ -n "$TCSH_VERSION" ]; then
    add_or_edit_line "$HOME/.tcshrc" "$script_to_trigger"
fi

# PowerShell
if [ -n "$PSVersionTable" ]; then
    add_or_edit_line "$HOME/.bash_profile" "$script_to_trigger"
fi

# Elvish
if command -v elvish &> /dev/null; then
    add_or_edit_line "$HOME/.elvish/rc.elv" "$script_to_trigger"
fi

# Add checks for other shell types if needed
