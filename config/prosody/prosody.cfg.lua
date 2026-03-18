-- 1. Глобальные настройки
admins = { "admin@your_server.ru" }
plugin_paths = { "/usr/lib/prosody/custom-modules" }

-- 2. Логи
log = "*console"

-- 3. Настройки безопасности
consider_bosh_secure = true
consider_websocket_secure = true
c2s_require_encryption = true
s2s_require_encryption = true
s2s_secure_auth = false
allow_registration = false

-- 4. Сетевые порты
http_ports = { 5280 }
http_interfaces = { "*" }
https_ports = { 5281 }
https_interfaces = { "*" }

-- 5. SSL
ssl = {
    certificate = "/etc/letsencrypt/live/npm-11/fullchain.pem";
    key = "/etc/letsencrypt/live/npm-11/privkey.pem";
}

-- 6. Хранилище и архивация
storage = "internal"
archive_expires_after = "60d"
mam_max_archive_query_results = 10000
default_archive_policy = "roster"

-- 7. Оптимизация
c2s_ping_timeout = 300
c2s_ping_interval = 120

-- 8. Модули
modules_enabled = {
    "register",
    "rest",
    "roster", "saslauth", "tls", "dialback", "disco", "c2s", "s2s",
    "bosh", "websocket", "http_files",
    "private", "blocklist", "vcard4", "vcard_legacy", "version",
    "uptime", "time", "ping", "pep",
    "admin_adhoc", "admin_shell",
    "muc", "invites", "invites_register",
    "carbons", "bookmarks", "csi_simple", "smacks", "mam",
    "http_file_share",  -- Для файлов
    "external_services", -- Для звонков (TURN)
    "conversejs",        -- conversejs web xmmp
}

-- Настройка раздачи файлов
http_files_dir = "/var/lib/prosody/http_files"
http_files_path = "/files"  -- URL путь к файлам

-- 9. HTTP File Upload 
http_file_share = {
    base_url = "https://your_server.ru:5281";

    -- Размер файла до 100 МБ
    max_file_size = 104857600;

    -- Директория для хранения
    upload_path = "/var/lib/prosody/http_upload";

    -- Квота на пользователя (1 ГБ)
    quota = 1073741824;

    -- Файлы хранятся 7 дней
    expire_after = 604800;

    -- Удаляем EXIF
    strip_exif = true;

    -- Только локальные пользователи
    --access = "local";
}

-- 10. Настройки HTTP
http_external_url = "https://your_server.ru:5281" -- Помогает модулям понимать внешний адрес

http_paths = {
    upload = "/upload"; -- Путь для модуля http_file_share
    files = "/files";  -- Путь для модуля http_files (ConverseJS и статика)
}

-- 11. HTTP модули
http_modules = {
    "bosh";
    "websocket";
    "files";
    "http_file_share";
}

-- 12. НАСТРОЙКИ CONVERSE.JS
-- conversejs_version = "11.0.0"  -- а не latest :)

conversejs_options = {
    -- ОСНОВНЫЕ НАСТРОЙКИ
    view_mode = "fullscreen";
    theme = "nord";

    -- параметры для MUC
    muc_domain = "conference.your_server.ru";
    muc_fetch_members = true; -- Явно запрашивать список участников
    muc_instant_rooms = false;
    allow_muc_invitations = true;
    allow_muc_creation = true;
    muc_nickname_from_jid = true;

    enable_emojione = true;
    debug = false;
    allow_registration = false;

    -- ОПТИМИЗАЦИЯ ЗАГРУЗКИ
    -- message_archiving = "always";
    -- archived_messages_page_size = 20;
    -- auto_fill_history_gaps = false;
    -- auto_load_history = false;
    -- lazy_load_all_contacts = true;
    -- lazy_load_vcards = false;

    -- OMEMO
    enable_smacks = true;
    omemo_default = true;
    -- omemo_include_device_id = true;

    -- Другие настройки
    allow_message_retraction = true;
    allow_message_correction = '2m';
    enable_emoji = true;
    enable_emojis = true;
    enable_smiles = true;
    locales = 'ru';
}

-- БЛОК conversejs_tags
conversejs_tags = {
    -- Тёмная тема (через http_files)
    -- [[<link rel="stylesheet" href="https://mysait.ru/css/conversejs_custom.css">]];

    -- OMEMO online lib
    [[<script src="https://cdn.conversejs.org/3rdparty/libsignal-protocol.min.js"></script>]];
    -- OMEMO offline
    -- [[<script src="/files/libsignal-protocol.min.js"></script>]];

    -- Favicon
    -- [[<link rel="icon" href="https://mysait.ru/favicon.ico" type="image/x-icon" />]];
    -- [[<link rel="shortcut icon" href="https://mysait.ru/favicon.ico" type="image/x-icon" />]];


};

-- настройки внешки conversejs
conversejs_name = "ABChat web"
conversejs_short_name = "ABChat"
conversejs_description = "Персональный чат с шифрованием данных"
-- conversejs_pwa_color = "#397491"

-- 13. ОСНОВНОЙ ХОСТ
VirtualHost "your_server.ru"
    ssl = {
        certificate = "/etc/letsencrypt/live/npm-11/fullchain.pem";
        key = "/etc/letsencrypt/live/npm-11/privkey.pem";
    }

    -- НАСТРОЙКИ REST ДЛЯ БОТА
    modules_enabled = { "rest"}
    
    -- rest_callback_url = "https://mysait.ru/xmpp_bot.php"
    -- rest_callback_content_type = "application/json"
    
    -- Разрешаем боту отправлять сообщения через REST
    rest_allowed_users = {
        ["bot@your_server.ru"] = { "out" } -- Ему нужно только отправлять
    }
    
    --- конец блока про бота

    -- ** ВАЖНО: Приоритет передачи файлов **
    -- Указываем, что файлы должны передаваться через HTTP Upload
    http_upload_upload_url = "https://your_server.ru:5281/upload"

    -- Отключаем Jingle для файлов, но оставляем для звонков
    jingle_file_transfers = false  -- Запрещаем Jingle для файлов

    -- TURN для звонков (оставляем как есть)
    external_services = {
        {
            name = "coturn-turn",
            type = "turn",
            transport = "udp",
            host = "your_server.ru",  
            port = 3478,
            secret = "UU1c6vpOcgAvzxnCCFvTox2vJAnWQYfI",
            ttl = 86400,
            restricted = true,
        },
        {
            name = "coturn-turn-tcp",
            type = "turn",
            transport = "tcp",
            host = "your_server.ru",
            port = 3478,
            secret = "UU1c6vpOcgAvzxnCCFvTox2vJAnWQYfI",
            ttl = 86400,
            restricted = true,
        },
        {
            name = "coturn-turns",
            type = "turns",
            transport = "tcp",
            host = "your_server.ru",
            port = 5349,
            secret = "UU1c6vpOcgAvzxnCCFvTox2vJAnWQYfI",
            ttl = 86400,
            restricted = true,
        },
        {
            name = "coturn-stun",
            type = "stun",
            host = "your_server.ru",
            port = 3478,
        },
        {
            name = "coturn-stuns",
            type = "stuns",
            host = "your_server.ru",
            port = 5349,
        },
    }

    -- MUC
    muc_mapper_domain = "your_server.ru"

    -- Приглашения
    invites_register = {
        rooms = {
            "general@conference.your_server.ru"
        },
        message = "Добро пожаловать!",
        from = "admin@your_server.ru",
        send_on_register = true,
    }

-- 14. MUC компонент
Component "conference.your_server.ru" "muc"
    name = "Конференции"
    restrict_room_creation = "local"
    modules_enabled = {
        "mam",
        "muc_mam",
        "muc_bot"           -- Модуль для ботов (позволяет писать в MUC без входа)
    }
    muc_room_default_persistent = true
    muc_room_default_public = true
    muc_room_default_members_only = false

    -- Хранить последние 500 сообщений в каждой комнате
    muc_log_by_default = true;
    muc_log_all_rooms = true;
    -- Лимит архива (в сообщениях)
    max_archive_messages = 1000;

    -- Настройки для ботов в MUC
    known_bots = { "bot@your_server.ru" }  
    bots_get_messages = false                 -- Бот не получает сообщения из комнаты
    ignore_bot_errors = true                   -- Игнорировать ошибки от бота
