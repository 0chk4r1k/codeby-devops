#!/bin/bash
FOLDER="$HOME/myfolder"

if [ ! -d "$FOLDER" ]; then
  exit 1
fi

FILE_COUNT=$(find "$FOLDER" -type f | wc -l)
echo "Total files in $FOLDER: $FILE_COUNT"

FILE2="$FOLDER/file2.txt"
if [ -f "$FILE2" ]; then
  chmod 664 "$FILE2"
fi

find "$FOLDER" -type f -empty -exec rm -f {} \;

for f in "$FOLDER"/*.txt; do
  if [ -f "$f" ] && [ ! -s "$f" ]; then
    continue
  fi
  head -n 1 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
