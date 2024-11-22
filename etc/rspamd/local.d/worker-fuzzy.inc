# Stores fuzzy hashes of messages.
# https://rspamd.com/doc/workers/fuzzy_storage.html
# This is a basic example configuration, adjust it for your needs

# number of worker instances to run
count = 1; # Disabled by default
bind_socket = "*:11335";

# Store the hashes in Redis.
backend = 'redis';
servers = "localhost:6379";
timeout = 1s;
db = 0;
password = 'yourRedisPassword';

# Expiration time of stored fuzzy hashes (default: 2 days)
expire = 30d;

# Allow localhost to perform changes to fuzzy storage.
allow_update = ["127.0.0.1", "::1"];
