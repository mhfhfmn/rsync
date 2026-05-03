#!/bin/bash

SOURCE="$HOME"
DESTINATION="/tmp/backup"
LOG="/var/log/backup_home.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log_message() {
    echo "$TIMESTAMP - $1" >> "$LOG"
    logger -t "backup_home" "$1"
}

mkdir -p "$DESTINATION"
 
log_message "Начало резервного копирования из $SOURCE в $DESTINATION"

rsync -avc --delete --exclude='.*' "$SOURCE/" "$DESTINATION/" 2>&1 | tee -a "$LOG"

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    log_message "Резервное копирование завершено успешно"
else
    log_message "Резервное копирование завершилось с ошибкой"
    exit 1
fi

FILE_COUNT=$(find "$DESTINATION" -type f | wc -l)
DIR_COUNT=$(find "$DESTINATION" -type d | wc -l)
BACKUP_SIZE=$(du -sh "$DESTINATION" | cut -f1)
log_message "Скопировано файлов: $FILE_COUNT, скопированно директорий: $DIR_COUNT Размер: $BACKUP_SIZE"

exit 0