# This script copies my current Obsidian notes on CASTEP as the README.md file, and pushes to GitHub.

#!/bin/bash

date=$(date +"%Y-%m-%d %H:%M:%S")

cp "/home/pablo/Documents/obsidian/Work ⚛️/Instruments/CASTEP.md" README.md

(zenity --info --text="CASTEP notes updated. Pushing to GitHub..." --timeout=2 --no-wrap --title="castep4dummies update") &

sleep 3

git status
git add .
git commit -m "Automatic update from Obsidian Notes on $date"

if [ $? -ne 0 ]; then
    (zenity --error --text="Git commit aborted! Did you modified the notes?" --no-wrap --title="castep4dummies update") &
    exit 2
fi

git push

# Check if the push was successful
if [ $? -ne 0 ]; then
    (zenity --error --text="Git push failed..." --no-wrap --title="castep4dummies update") &
    exit 2
fi

(zenity --info --text="Done!  :D" --timeout=1 --no-wrap --title="castep4dummies update") &

