#!/bin/sh

# iTunes music syncronisation utility for android devices
# 2018 Angus Freudenberg
# Version 0.1.0 

# Constants
PATH="/usr/local/bin"
MUSIC_LOCAL="~/Music/iTunes/iTunes\ Media/Music/"
MUSIC_REMOTE="/storage/0000-0000/Music"

cd $PATH

# Check if a device is connected via USB
check_if_connected() {
	echo "Checking if your Android device is connected..."
	device_state=$(adb get-state)
        if [ "$device_state" != "device" ]
            then
		    exit 1
        fi
	device=$(adb get-serialno)
	echo "$device is connected, beginning iTunes syncronisation..."
    echo
}

# Synchronise music from iTunes library to remote sd card
sync_music() {
    adb-sync --dry-run $MUSIC_LOCAL $MUSIC_REMOTE
    echo
    echo "iTunes sync complete!"
}

# Confirm that adb is present and functional on the host system
	check_adb=$(adb help 2>&1) || {
		echo >&2 "ERROR: adb not functional, make sure it is in your PATH:"
		echo "$PATH"
		exit 1
}

# Terminate adb sessison
disconnect_device() {
	output=$(adb disconnect)
	echo "It is now safe to unplug your device..."
}

# MAIN
check_if_connected
sync_music
disconnect_device
exit 1
