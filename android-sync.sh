#!/bin/sh

__TITLE__="Android Sync"
__DESCRIPTION__="iTunes music synchronisation utility for android devices"
__AUTHOR__="Angus Freudenberg, 2018"
__VERSION__="0.2.1-beta"

echo "$__TITLE__ - $__VERSION__\n$__DESCRIPTION__\n$__AUTHOR__"
echo

# PATH definitions
SOURCE="$( cd "$(dirname "$0")" ; pwd -P )"
PATH=$PATH:/bin:/usr/bin:/usr/local/bin
export PATH

# Default iTunes library location
HOST_MUSIC_PATH="$HOME/Music/iTunes/iTunes Media/Music"
DEVICE_PLAYLIST_PATH=storage/emulated/0

adb_check()
{
    # Try to launch adb to confirm it is present on the system

    cmd=$(adb help 2>&1) ||
        {
        echo >&2 "ERROR: adb not functional, make sure it is in your PATH:"
        echo $PATH
        exit 1
        }
}

check_device_connection()
{
    # Check if a device is connected via USB

    echo "Checking if your Android device is connected..."
    cmd=$(adb start-server 2>&1)
    device_state=$(adb get-state 2>&1)
        if [ "$device_state" != "device" ]
            then
            echo >&2 "ERROR: No device was detected."
            exit 1
        fi

    device=$(adb get-serialno)
    echo ${device} "is connected, finding external storage..."
}

disconnect_device()
{
    # Kill the adb service

    cmd=$(adb kill-server 2>&1)
    echo "It is now safe to unplug your device..."
    exit 1
}

get_storage_path()
{
    # Try to get the UUID of the sd_card mounted in /storage and create a Music folder if it doesn't exists.
    # TODO Default to internal storage if an external storage device isn't present

    sd_name=$(adb shell "cd storage/****-****/; pwd | sed 's#.*/##'") ||
    {
        echo 'ERROR: There was a problem accessing the external storage device. Disengaging...'
        disconnect_device
    }
    echo 'Found external storage device:' ${sd_name}
    cmd=$(adb shell "cd storage/${sd_name}; mkdir -p Music")
    echo

    # Defined path of the SD card and music folder
    device_music_path=/storage/${sd_name}/Music
}

synchronise_music()
{
    # Synchronise music from iTunes library to device sd card
    #TODO - Determine how to sync music files that have added/updated lyrics ?md5 checksum

    echo "Synchronising music...."
    adb-sync -f -d "${HOST_MUSIC_PATH}/" "${device_music_path}" ||
    {
        echo "ERROR: A problem occurred while transferring your music. Disengaging..."
        disconnect_device
    }
    echo
}

synchronise_playlists()
{
    # Synchronise playlists from iTunes library to device sd card
    #TODO - Dynamic switching between internal and external storage for better compatibility with music players

    echo "Generating temporary directory..."
    playlist=$(mktemp -d)
    echo "Extracting playlists to temporary directory..."
    java -jar itunesexport.jar "${HOST_MUSIC_PATH}" -outputDir="${playlist}/" -fileTypes=ALL ||
    {
        echo "ERROR: A problem occurred while exporting your playlists. Disengaging..."
        rm -rf ${playlist}
        disconnect_device
    }
    echo
    echo "Synchronising playlists..."
    cmd=$(adb shell "cd ${DEVICE_PLAYLIST_PATH}; mkdir -p Playlists")
    adb-sync -f -d "${playlist}/" "${DEVICE_PLAYLIST_PATH}/Playlists" ||
    {
        echo "A problem occurred while transferring your playlists. Disengaging..."
        disconnect_device
    }
    echo
}

clean_up_files()
{
    # Remove temporary files and redundant .DS_Store files from music folder

    echo "Cleaning up..."
    rm -rf ${playlist}
    cmd=$(adb shell "cd storage/${sd_name}/Music/; find . -name '.DS_Store' -delete")
    echo "iTunes synchronisation complete!"
    echo
}

# Main

adb_check
check_device_connection
get_storage_path
synchronise_music
synchronise_playlists
clean_up_files
disconnect_device