#!/bin/bash
FOLDER="$HOME/myfolder"

mkdir -p "$FOLDER"

FILE1="$FOLDER/file1.txt"
echo "Hello!" > "$FILE1"
date >> "$FILE1"

FILE2="$FOLDER/file2.txt"
touch "$FILE2"
chmod 777 "$FILE2"

FILE3="$FOLDER/file3.txt"
RANDOM_STRING=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)
echo "$RANDOM_STRING" > "$FILE3"

# 4-5. Два пустых файла
touch "$FOLDER/file4.txt" "$FOLDER/file5.txt"
