-- 1. Global settings
admins = { "admin@your_server.ru" }
plugin_paths = { "/usr/lib/prosody/custom-modules" }

-- 2. Logging
log = {
      { levels = { min = "info" }, to = "console" };
}

-- 3. Security settings
consider_bosh_secure = true
consider_websocket_secure = true
c2s_require_encryption = true
s2s_require_encryption = true
s2s_secure_auth = false
allow_registration = false

-- 4. Network ports
http_ports = { 5280 }
http_interfaces = { "*" }
https_ports = { 5281 }
https_interfaces = { "*" }

-- 5. SSL
ssl = {
    certificate = "/etc/letsencrypt/live/npm-11/fullchain.pem";
    key = "/etc/letsencrypt/live/npm-11/privkey.pem";
}

-- 6. Storage and archiving
storage = "internal"
archive_expires_after = "60d"
mam_max_archive_query_results = 10000
default_archive_policy = "roster"

-- 7. Optimization
c2s_ping_timeout = 300
c2s_ping_interval = 120

-- 8. Modules
modules_enabled = {
    "register",
    "rest",
    "roster", "saslauth", "tls", "dialback", "disco", "c2s", "s2s",
    "bosh", "websocket", "http_files",
    "private", "blocklist", "vcard4", "vcard_legacy", "version",
    "uptime", "time", "ping", "pep",
    "admin_adhoc", "admin_shell",
    "invites", "invites_register",
    "carbons", "bookmarks", "csi_simple", "smacks", "mam",
    "http_file_share",   -- For file sharing
    "external_services", -- For calls (TURN)
    "conversejs",        -- Converse.js web XMPP client
}

-- File serving setup
http_files_dir = "/var/lib/prosody/http_files"
http_files_path = "/files"  -- URL path to files
http_file_share_size_limit = 104857600 -- 100 MB limit

-- 9. HTTP File Upload
http_file_share = {
    base_url = "https://your_server.ru:5281";

    -- Storage directory
    upload_path = "/var/lib/prosody/http_upload";

    -- Per-user quota (1 GB)
    quota = 1073741824;

    -- Files are kept for 7 days
    expire_after = 604800;

    -- Strip EXIF metadata
    strip_exif = true;

    -- Local users only
    --access = "local";
}

-- 10. HTTP settings
http_external_url = "https://your_server.ru:5281" -- Helps modules determine the external URL

http_paths = {
    upload = "/upload"; -- Path for the http_file_share module
    files = "/files";   -- Path for the http_files module (Converse.js and static files)
}

-- 11. HTTP modules
http_modules = {
    "bosh";
    "websocket";
    "files";
    "http_file_share";
}

-- 12. CONVERSE.JS SETTINGS
-- conversejs_version = "11.0.0"  -- not "latest" :)

conversejs_options = {
    -- MAIN SETTINGS
    view_mode = "fullscreen";
    theme = "nord";

    -- MUC options
    muc_domain = "conference.your_server.ru";
    muc_fetch_members = true; -- Explicitly request the member list
    muc_instant_rooms = false;
    allow_muc_invitations = true;
    allow_muc_creation = true;
    muc_nickname_from_jid = true;

    enable_emojione = true;
    debug = false;
    allow_registration = false;

    -- LOAD OPTIMIZATION
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

    -- Other settings
    allow_message_retraction = true;
    allow_message_correction = '2m';
    enable_emoji = true;
    enable_emojis = true;
    enable_smiles = true;
    locales = 'ru';
}

-- conversejs_tags block
conversejs_tags = {
    -- Dark theme (via http_files)
    -- [[<link rel="stylesheet" href="https://mysait.ru/css/conversejs_custom.css">]];

    -- OMEMO online lib
    [[<script src="https://chat.conversejs.org/3rdparty/libsignal-protocol.min.js"></script>]];
    -- OMEMO offline
    -- [[<script src="/files/libsignal-protocol.min.js"></script>]];

    -- Favicon
    -- [[<link rel="icon" href="https://mysait.ru/favicon.ico" type="image/x-icon" />]];
    -- [[<link rel="shortcut icon" href="https://mysait.ru/favicon.ico" type="image/x-icon" />]];
};

-- Converse.js appearance settings
conversejs_name = "ABChat web"
conversejs_short_name = "ABChat"
conversejs_description = "Personal chat with data encryption"
-- conversejs_pwa_color = "#397491"

-- 13. MAIN HOST
VirtualHost "your_server.ru"
    ssl = {
        certificate = "/etc/letsencrypt/live/npm-11/fullchain.pem";
        key = "/etc/letsencrypt/live/npm-11/privkey.pem";
    }

    -- REST SETTINGS FOR THE BOT
    modules_enabled = { "rest" }

    -- rest_callback_url = "https://mysait.ru/xmpp_bot.php"
    -- rest_callback_content_type = "application/json"

    -- Allow the bot to send messages via REST
    rest_allowed_users = {
        ["bot@your_server.ru"] = { "out" } -- It only needs to send
    }

    --- end of bot block

    -- ** IMPORTANT: File transfer priority **
    -- Specify that files must be transferred via HTTP Upload
    http_upload_upload_url = "https://your_server.ru:5281/upload"

    -- Disable Jingle for files, but keep it for calls
    jingle_file_transfers = false  -- Disable Jingle for files

    -- TURN for calls (keep as is)
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

    -- Invitations
    invites_register = {
        rooms = {
            "general@conference.your_server.ru"
        },
        message = "Welcome!",
        from = "admin@your_server.ru",
        send_on_register = true,
    }

-- 14. MUC component
Component "conference.your_server.ru" "muc"
    name = "Conferences"
    restrict_room_creation = "local"
    modules_enabled = {
        "mam",
        "muc_mam",
        "muc_bot"           -- Bot module (allows posting to MUC without joining)
    }
    -- Default settings for new rooms
    muc_room_default_persistent = true
    muc_room_default_public = true
    muc_room_default_members_only = true
    -- muc_room_default_language = "ru"

    -- MAM archiving settings (the most important part for history)
    muc_log_by_default = true          -- Enable archiving for new rooms by default
    log_all_rooms = true               -- Force archiving for all rooms (overrides per-room setting)
    muc_log_expires_after = "1y"       -- How long to keep history (e.g. one year). "never" = forever.
    max_archive_query_results = 50     -- How many messages a client can request at once (default 50)

    -- Bot settings for MUC
    known_bots = { "bot@your_server.ru" }
    bots_get_messages = false                 -- The bot does not receive room messages
    ignore_bot_errors = true                  -- Ignore errors from the bot
