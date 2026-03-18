local st = require "util.stanza";
local hmac_sha1 = require "util.hashes".hmac_sha1;
local base64 = require "util.encodings".base64.encode;

local turn_host = module:get_option_string("turn_external_host", module.host);
local turn_port = module:get_option_number("turn_external_port", 3478);
local turn_secret = module:get_option_string("turn_external_secret");
local turn_ttl = module:get_option_number("turn_external_ttl", 86400);

if not turn_secret then
    module:log("error", "turn_external_secret not specified! External TURN will not work.");
    return;
end

module:hook("account-disco-info", function(event)
    local reply = event.reply;
    reply:tag("external", { xmlns = "urn:xmpp:extdisco:2" })
        :tag("service", {
            type = "stun",
            host = turn_host,
            port = tostring(turn_port),
            transport = "udp",
        }):up()
        :tag("service", {
            type = "turn",
            host = turn_host,
            port = tostring(turn_port),
            transport = "udp",
        });
    
    local expires = os.time() + turn_ttl;
    local username = tostring(expires);
    local password = base64(hmac_sha1(turn_secret, username));
    
    reply:tag("credentials")
        :tag("username"):text(username):up()
        :tag("password"):text(password):up()
    :up():up():up();
end);
