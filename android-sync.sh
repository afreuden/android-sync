#!/bin/sh

# iTunes music synchronisation utility for android devices
# 2018 Angus Freudenberg
# Version 0.1.5

# PATH definitions
PATH=$PATH:/bin:/usr/bin:/usr/local/bin
export PATH

TITLE="Android Sync"
DESCRIPTION="iTunes music synchronisation utility for android devices"
AUTHOR="Angus Freudenberg 2018"
VERSION="0.1.5"

echo "$TITLE - $VERSION\n$DESCRIPTION\n$AUTHOR"
echo

# Default iTunes library location
HOST_MUSIC_PATH="$HOME/Music/iTunes/iTunes\ Media/Music/"

# Check if adb is present and functional on the host system
check_adb=$(adb help 2>&1) || {
    echo >&2 "ERROR: adb not functional, make sure it is in your PATH:"
    echo $PATH
    exit 1
}

# Check if a device is connected via USB
echo "Checking if your Android device is connected..."
device_state=$(adb get-state 2>&1)
    if [ "$device_state" != "device" ]
        then
        echo >&2 "ERROR: No device was detected"
        echo "Exiting..."
        exit 1
    fi

device=$(adb get-serialno)
echo ${device} "is connected, finding external storage..."

# Get the UUID of the sd_card mounted in /storage and create a Music folder if it doesn't exists
sd_name=$(adb shell "cd storage/????-????; pwd | sed 's#.*/##'")
echo 'Found external storage device:' ${sd_name}
shell=$(adb shell "cd storage/${sd_name}; mkdir -p Music")
echo

# Defined path of the SD card and music folder
device_music_path=/storage/${sd_name}/Music

# Synchronise music from iTunes library to device sd card
echo "Synchronising music...."
adb-sync "${HOST_MUSIC_PATH}" "${device_music_path}" || {
    echo "A problem occurred while transferring your music"
    exit 1
}
echo

# Synchronise playlists from iTunes library to device sd card
echo "Generating temporary directory..."
playlist=$(mktemp -d)
echo "Extracting playlists to temporary directory..."
java -jar itunesexport.jar "${HOST_MUSIC_PATH}" -outputDir="${playlist}/" -fileTypes=ALL || {
    echo "A problem occurred while exporting your playlists"
    exit 1
}
echo
echo "Synchronising playlists..."
adb-sync "${playlist}/" "${device_music_path}" || {
    echo "A problem occurred while transferring your music"
    exit 1
}
echo
echo "Cleaning up..."
rm -rf ${playlist}
shell=$(adb shell "cd storage/${sd_name}/Music/; find . -name '.DS_Store' -delete")
echo "iTunes synchronisation complete!"
echo

# Terminate adb session
disconnect=$(adb disconnect 2>&1)
echo "It is now safe to unplug your device..."
exit 1