#!/bin/bash

# Test if SIP is disabled
sip_status="$(csrutil status)"
if [[ $sip_status != *"disabled"* ]]; then
    echo "Please disable SIP before running this script"
    exit 1
else
    # Install developer tools for xcode
    xcode-select --install
    read -p "Press any key when xcode is installed"

    # OSX fuse part
    curl -sSL https://github.com/osxfuse/osxfuse/releases/download/osxfuse-3.6.0/osxfuse-3.6.0.dmg -o osxfuse.dmg
    hdiutil attach osxfuse.dmg
    sudo installer -pkg /Volumes/FUSE*/*.pkg -target /
    diskutil unmount /Volumes/FUSE*
    rm osxfuse.dmg

    # Homebrew part
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask install osxfuse
    brew install ntfs-3g

    # Effective volume mount
    read -p "If you already run this script after this point, you shouldn't backup"
    read -e -p "Do you need to backup ? (yes/no)" "no" choice

    if [[ $choice == "yes" ]]; then
        sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
    fi
    # No harm here
    sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs
fi
