# This script copies my current Obsidian notes on CASTEP as the README.md file, and pushes to GitHub.

#!/bin/bash

date=$(date +"%Y-%m-%d %H:%M:%S")

original="/home/pablo/Documents/obsidian/Work ⚛️/Instruments/CASTEP.md"
final="README.md"

if diff $original $final >/dev/null; then
    # If the files are the same, show a message and exit
    zenity --info --text="No changes detected. Exiting..." --timeout=2 --no-wrap --title="castep4dummies update"
    exit 0
fi

cp "$original" "$final"

(zenity --info --text="CASTEP notes updated. Pushing to GitHub..." --timeout=2 --no-wrap --title="castep4dummies update") &

git status
git add .
git commit -m "Automatic update from Obsidian Notes on $date"

if [ $? -ne 0 ]; then
    (zenity --warning --text="Git commit aborted! Did you modified the notes?" --no-wrap --title="castep4dummies update") &
    exit 2
fi

git push

# Check if the push was successful
if [ $? -ne 0 ]; then
    (zenity --warning --text="Git push failed..." --timeout=2 --no-wrap --title="castep4dummies update") &
    exit 2
fi

(zenity --info --text="Done!  :D" --timeout=1 --no-wrap --title="castep4dummies update") &

