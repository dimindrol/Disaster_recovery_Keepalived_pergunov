# Домашнее задание к занятию "Disaster recovery и Keepalived" - Пергунов Д.В

### Задание 1
1. Настроили отслеживание состояния интерфейсов Gi0/0
![конфиг роутер 1](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/assets/103885836/248846d1-953f-4f20-9d3d-0b69724825a5)
![конфиг роутер 2](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/assets/103885836/578c00b7-803c-4c66-be8a-9c1dc2dcd39b) 
2. Разорвали первый кабель между одним из маршрутизаторов и Switch0, и проверили пинг
![маршрут 1](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/assets/103885836/8d82f52a-3b24-4dc6-9306-0b6cb357f94f)
3. Разорвали второй кабель между одним из маршрутизаторов и Switch0, и проверили пинг
![маршрут 2](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/assets/103885836/64c00c95-6471-4d73-8c9c-604c5703c8b8)
4. [схема Cisco packet tracer](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/blob/77cce4f6841b299877a23eaf236662773d45cbd5/hsrp_advanced.pkt)


### Задание 2

1. Запустили две машины и настроили keeperlived
2. Установили Nginx
3. Написали скрипт который проверяет наличие файла Index.html и проверяет открыт ли порт и записывает изменения в файл
[Ссылка на скрипт](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/blob/77cce4f6841b299877a23eaf236662773d45cbd5/script.sh)

```
#!bin/bash
PORT=$(bash -c 'exec 3<> /dev/tcp/127.0.0.1/80;echo $?' 2>/dev/null) #Проверка порта
FILE=/var/www/html/index.nginx-debian.html  # Путь до файла

if [[ $PORT -eq 0 && -f "$FILE" ]]; then 
  echo "0" > /etc/keepalived/script/exit_status #Успешная проверка в файл записывается код 0
  exit 0
else
  echo "1" > /etc/keepalived/script/exit_status #Проверка завершилась с ошибкой код 1
  exit 1
fi
```
4. Настроили keeperlived для запуска скрипт
[Ссылка на конфиг](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/blob/main/keepalived.conf)
```
global_defs {
  script_user root
  enable_script_security
}

vrrp_script file_track {
script "/etc/keepalived/script/script.sh"
interval 3
}

vrrp_instance VI_1 {
        state MASTER
        interface enp0s3
        virtual_router_id 15
        priority 255
        advert_int 1


        virtual_ipaddress {
              192.168.0.254/24
        }


        track_script {
                   file_track
                }
}
```
5. Проверяем корректность выполнения скрипта переименовываем файл или останавливаем nginx.
Переключение с помощью скрипта выполняется корректно
![image](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/assets/103885836/166b9cef-5f79-4b6f-8803-c029f7504b54)
![image](https://github.com/dimindrol/Disaster_recovery_Keepalived_pergunov/assets/103885836/38720100-bbd8-4ef6-ad83-fd5e2cc08882)









