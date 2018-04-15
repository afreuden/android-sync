# android-sync
A shell script to synchronise iTunes music and other data between macOS and Android

## Description
This simple shell script allows a user with a macOS computer to synchronise their iTunes library and playlists to an Android device. It is able to track changes to your library and playlists such as additions and deletions.

## Dependencies
Android Debug Bridge <br />
Python 3 <br />
Java VM<br />
adb-sync<br />
itunesexport.jar<br />
scala-library.jar

## Usage
- Ensure USB debugging is enabled on your Android device <br />
- Plug Android device into an available USB port <br />
- The script should be set as an executable. If not, then chmod +x android-sync<br />
- There are many ways to execute the program:<br />
    - Open a terminal window, navigate to the directory you installed and type: ./android-sync<br />
    - Move the executable and dependencies to /usr/local/bin and launch by typing android-sync in a terminal<br />
    - Double clicking android-sync in Finder (or create an alias and place on your desktop)

## Current Limitations
- By design, this script requires USB debugging enabled under Developer Options in Android Settings. There is no way around this.
- The storage path is fixed to an external mounted device in the `/storage` directory. As such, this will only work on devices with Android 6.0 and higher.<br />
- `adb-sync.py` cannot detect music files that have been updated with lyrics as this does not change the checksum of the files.<br />
- There is currently no way to filter the music library, it will synchronise every song have in iTunes.<br />
- At this stage, there is not support for playlist filtering, however `itunesexport.jar` does support it and may be implemented at a later date.<br />
- This has not been tested on an unrooted Android device so I cannot comment on whether this script will work. However, there is no reason why it shouldn't.
- There is no implemented function that checks if there is enough free space on an SD card, so they're may be undocumented issues if a library larger than the external storage is transferred over.

## Credits
This utility uses the following modules: <br />
- adb-sync.py, a python implementation of the adb push -sync feature but with more granular control over synchronisation of files<br />
- itunesexport.jar, a java program that parses the iTunes Library.xml into .m3u playlists
