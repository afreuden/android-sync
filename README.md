# android-sync
A command-line utility to synchronise iTunes music and other data between macOS and Android

## Description
This simple shell script allows a user with a macOS computer to synchronise their iTunes library and playlists to an Android device. It is able to track changes to your lirbary and playlists such as additions and deletions.

## Dependencies
Android Debug Bridge <br />
Python 3 <br />
Java VM<br />
adb-sync<br />
itunesexport.jar<br />
scala-library.jar

## Usage
Ensure USB debugging is enabled on your Android device <br />
Plug Android device into an available USB port <br />
The script should be set as an executable. If not, then chmod +x android-sync<br />
There are many ways to execute the program:<br />
Open a terminal window, navigate to the directory you installed and type: ./android-sync<br />
Move the executable and dependencies to /usr/local/bin and launch by typing android-sync in a terminal<br />
Double clicking android-sync in Finder (or create an alias and place on your desktop)

## Current Limitations
The storage path is fixed to an external mounted device in the /storage directory. As such, this will only work with Android 6.0+<br />
adb-sync cannot detect music files that have been updated with lyrics<br />
There is currently no way to filter your library, it will synchronise every song you have in iTunes<br />
There are no options to filter what playlists to synchronise as itunesexport.java exports every playlist <br />
This has not been tested on an unrooted Android device so I cannot comment on whether this script will work

## Credits
This utility uses the following modules: <br />
adb-sync.py, a pyhton implementation of the adb push -sync feature but with more granular control over synchronisation of files<br />
itunesexport.java, a java program that parses the iTunes Library.xml into .m3u playlists
