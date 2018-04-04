#!/bin/sh

# iTunes music synchronisation utility for android devices
# 2018 Angus Freudenberg
# Version 0.1.5

PATH=$PATH:/bin:/usr/bin:/usr/local/bin
export PATH

TITLE="Android Sync"
DESCRIPTION="iTunes music synchronisation utility for android devices"
AUTHOR="Angus Freudenberg 2018"
VERSION="0.1.5"

echo "$TITLE\n$DESCRIPTION\n$AUTHOR\n$VERSION"
echo

HOST_MUSIC_PATH="$HOME/Music/iTunes/iTunes\ Media/Music/"

# Confirm that adb is present and functional on the host system
check_adb=$(adb help 2>&1) || {
    echo >&2 "ERROR: adb not functional, make sure it is in your PATH:"
    echo $PATH
    exit 1
}

# Check if a device is connected via USB
echo "Checking if your Android device is connected..."
device_state=$(adb get-state)
    if [ "$device_state" != "device" ]
        then
        exit 1
    fi
device=$(adb get-serialno)
echo ${device} "is connected, finding external storage..."

# Get the UUID of the sd_card mounted in /storage
sd_name=$(adb shell "cd storage/????-????; pwd | sed 's#.*/##'")
echo 'Found external storage device:' ${sd_name}
echo

# Defined path of the SD card and music folder
device_music_path=/storage/${sd_name}/Music

# Synchronise music from iTunes library to device sd card
echo "Synchronising music...."
adb-sync "${HOST_MUSIC_PATH}" "${device_music_path}"
echo

# Synchronise playlists from iTunes library to device sd card
echo "Generating temporary folder..."
playlist=$(mktemp -d)
echo "Extracting playlists..."
java -jar itunesexport.jar "${HOST_MUSIC_PATH}" -outputDir="${playlist}/" -fileTypes=ALL
echo
echo "Synchronising playlists..."
adb-sync "${playlist}/" "${device_music_path}"
echo
echo "Cleaning up..."
rm -rf ${playlist}
echo "iTunes synchronisation complete!"
echo

# Terminate adb session
adb disconnect
echo "It is now safe to unplug your device..."
