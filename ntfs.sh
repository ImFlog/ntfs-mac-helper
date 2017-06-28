#!/bin/bash

# Test if SIP is disabled
sip_status="$(csrutil status)"
if [[ $string == *"disabled"* ]]; then
    echo "Please disable SIP before running this script"
    exit 1
else
    # OSX fuse part
    curl -sSL https://github.com/osxfuse/osxfuse/releases/download/osxfuse-3.6.0/osxfuse-3.6.0.dmg -o osxfuse.dmg
    VOLUME=$(hdiutil attach osxfuse.dmg | tail -1 | awk '{print $1}')
    cp -r "$VOLUME/"*.app /Applications/
    diskutil unmount "$VOLUME"

    # Homebrew part
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask install osxfuse
    brew install homebrew/fuse/ntfs-3g

    # Effective volume mount
    sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
    sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs

    # TODO : cleanup
fi
