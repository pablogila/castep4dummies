# This script copies my current Obsidian notes on CASTEP as the README.md file, and pushes to GitHub.

#!/bin/bash

date=$(date +"%Y-%m-%d %H:%M")
original="/home/pablo/Documents/obsidian/Work ⚛️/Instruments/CASTEP.md"
final="README.md"

if diff -q "$original" "$final" >/dev/null; then
    zenity --warning --text="No changes detected." --timeout=1 --no-wrap --title="castep4dummies update"
    exit 0
fi

cp "$original" "$final"

(zenity --info --text="README.md updated. Pushing to GitHub..." --timeout=1 --no-wrap --title="castep4dummies update") &

git fetch

if [ $(git rev-list HEAD...origin/master --count) -ne 0 ]; then
    (zenity --error --text="Changes were detected in the remote repository. Check it manually..." --no-wrap --title="castep4dummies update") &
    exit 0
fi

git status
git add .

git commit -m "Automatic update from Obsidian on $date"

if [ $? -ne 0 ]; then
    (zenity --warning --text="Git commit failed. Check it manually..." --no-wrap --title="castep4dummies update") &
    exit 0
fi

git push

# Check if the push was successful
if [ $? -ne 0 ]; then
    (zenity --error --text="Git push failed. Check it manually..." --no-wrap --title="castep4dummies update") &
    exit 0
fi

(zenity --info --text="✅ Done!" --timeout=1 --no-wrap --title="castep4dummies update") &

