#!/bin/bash

# Задаем константу для директории
FOLDER="$HOME/myfolder"

# Если директории нет - выходим их скрипта
if [ ! -d "$FOLDER" ]; then
  exit 1
fi

# Подсчет количества файлов
FILE_COUNT=$(find "$FOLDER" -type f | wc -l)
echo "Total files in $FOLDER: $FILE_COUNT"

# Обработка второго файла - меняем права
FILE2="$FOLDER/file2.txt"
if [ -f "$FILE2" ]; then
  chmod 664 "$FILE2"
fi

# Удаляем пустые файлы
find "$FOLDER" -type f -empty -exec rm -f {} \;

# Оставляем в оставшихся файлах только первую строку
for f in "$FOLDER"/*.txt; do
  head -n 1 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
