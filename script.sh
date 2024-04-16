#!bin/bash

PORT=$(bash -c 'exec 3<> /dev/tcp/127.0.0.1/80;echo $?' 2>/dev/null)
FILE=/var/www/html/index.nginx-debian.html

if [[ $PORT -eq 0 && -f "$FILE" ]]; then
  echo "0" > /etc/keepalived/script/exit_status
  exit 0
else
  echo "1" > /etc/keepalived/script/exit_status
  exit 1
fi
