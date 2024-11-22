-- # rspamd.local.lua
-- Please read  https://rspamd.com/doc/developers/writing_rules.html#configuration-files

-- For a better overview and code handling I prefer snippets:
-- Include extra lua files from $LOCAL_CONFDIR/local.d/lua.d/*.lua
local local_conf = rspamd_paths['LOCAL_CONFDIR']
local f = io.popen("ls -1 " .. local_conf .. "/local.d/lua.d/*.lua")

if f then
  for mod in f:lines() do
    dofile(mod)
  end
end
