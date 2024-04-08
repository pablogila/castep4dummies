# This script copies my current Obsidian notes on CASTEP as the README.md file, and pushes to GitHub.

#!/bin/bash

date=$(date +"%Y-%m-%d %H:%M:%S")

cp "/home/pablo/Documents/obsidian/Work ⚛️/Instruments/CASTEP.md" README.md

(zenity --info --text="CASTEP notes updated. Pushing to GitHub..." --timeout=1 --no-wrap --title="castep4dummies update") &

git status
git add .
git commit -m "Automatic update from Obsidian Notes on $date"
git push

(zenity --info --text="Push completed!  :D" --timeout=1 --no-wrap --title="castep4dummies update") &

