#!/bin/bash

# Задаем константу для директории
FOLDER="$HOME/myfolder"

# Создаем директорию, если она существует, - флаг -p поможет избежать ошибки
mkdir -p "$FOLDER"

# 1. Файл с приветствием и текущей датой
FILE1="$FOLDER/file1.txt"
echo "Hello!" > "$FILE1"
date >> "$FILE1"

# 2. Пустой файл с правами 777
FILE2="$FOLDER/file2.txt"
touch "$FILE2"
chmod 777 "$FILE2"

# 3. Файл с рандомной строкой
FILE3="$FOLDER/file3.txt"
RANDOM_STRING=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)
echo "$RANDOM_STRING" > "$FILE3"

# 4-5. Два пустых файла
touch "$FOLDER/file4.txt" "$FOLDER/file5.txt"
