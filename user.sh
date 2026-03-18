#!/bin/bash

# Настройки
DOMAIN="your_server.ru"
CONTAINER="prosody"
# Путь к аккаунтам на хосте (с учетом кодирования точки %2e)
ACCOUNTS_PATH="./data/prosody/your_server%2ru/accounts/"

case "$1" in
    -a)
        read -p "Введите имя нового юзера: " UNAME
        sudo docker compose exec $CONTAINER prosodyctl adduser $UNAME@$DOMAIN
        ;;
    -p)
        if [ -z "$2" ]; then echo "Укажи имя: $0 -p <username>"; exit 1; fi
        sudo docker compose exec $CONTAINER prosodyctl passwd $2@$DOMAIN
        ;;
    -d)
        if [ -z "$2" ]; then echo "Укажи имя: $0 -d <username>"; exit 1; fi
        sudo docker compose exec $CONTAINER prosodyctl deluser $2@$DOMAIN
        ;;
    -l)
        if [ -d "$ACCOUNTS_PATH" ]; then
            echo "Список пользователей сервера $DOMAIN:"
            echo "-----------------------------------"
            sudo ls -1 "$ACCOUNTS_PATH" | sed 's/\.dat$//'
            echo "-----------------------------------"
        else
            echo "Ошибка: папка с аккаунтами не найдена. Проверь путь или создай первого юзера."
        fi
        ;;
    *)
        echo "Использование:"
        echo "  $0 -a           - Создать юзера"
        echo "  $0 -p <user>    - Поменять пароль"
        echo "  $0 -d <user>    - Удалить юзера"
        echo "  $0 -l           - Показать список всех юзеров"
        exit 1
        ;;
esac

