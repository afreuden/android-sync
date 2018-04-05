# android-sync
A command-line utility to synchronise iTunes music and other data between macOS and Android

## Dependencies
Android Debug Bridge <br />
Python 3 <br />
Java VM<br />

## Usage
Ensure USB debugging is enabled on your Android device <br />
Plug Android device into an available USB port <br />
The script should be set as an executable. If not, then chmod +x android-sync.sh <br />
Open a terminal window and type: ./android-sync.sh

## Current Limitations
The storage path is fixed to an external mounted device in the /storage directory. Different manufacturers and Android versions mount external storage in different paths <br />
The script assumes you already have a folder named "Music" in the root directory of the SD card <br />
There are no options to filter what playlists to synchronise as itunesexport.java exports every playlist <br />
This has not been tested on an unrooted Android device so I cannot comment on whether this technique will work

## Credits
This utility uses the following modules: <br />
adb-sync.py, a pyhton implementation of adb push -sync<br />
itunesexport.java, a java program that parses the iTunes Library.xml into .m3u playlists
