-- /etc/rspamd/local.d/lua.d/local_fuzzy_autolearn.lua
-- Source of inspiration: https://github.com/rspamd/rspamd/discussions/4897

-- Local Fuzzy autolearn
-- This rule automatically feeds the local fuzzy store with the incoming e-mails.
-- Please read https://rspamd.com/doc/modules/fuzzy_check.html for setting up your own fuzzy store.
-- With this rule I flag the hashes with 11 (definitly spam), 12 (user training via mail store) and 13 (definitly ham).
-- You also have to setup the correspondenting symbols weights in /etc/rspamd/local.d/fuzzy_group.conf

-- Please adjust the flags, weight and min/max scores respective your needs:
local FUZZY_WEIGHT_SPAM = 20
local FUZZY_FLAG_SPAM = 11
local MAX_SCORE_SPAM = 30
local MIN_SCORE_SPAM = 12

local FUZZY_WEIGHT_PROB = 5
local FUZZY_FLAG_PROB = 12
local MAX_SCORE_PROB = 11.99
local MIN_SCORE_PROB = 8

local FUZZY_WEIGHT_HAM = -2
local FUZZY_FLAG_HAM = 13
local MAX_SCORE_HAM = 4
local MIN_SCORE_HAM = -2

-- This function checks if auto_learn is triggered through a milter channel.
-- Otherwise this function will always be triggered if you just scan an email
-- in the web frontend of rspamd:
local function isMilter (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

rspamd_config.LEARN_FUZZY_LOCAL = {
  callback = function(task)
    local sc = task:get_metric_score()
    local fl = task:get_flags()

	if isMilter(fl, 'milter') then
		if (sc[1] <= MAX_SCORE_SPAM and sc[1] >= MIN_SCORE_SPAM)
			then rspamd_plugins.fuzzy_check.learn(task, FUZZY_FLAG_SPAM, FUZZY_WEIGHT_SPAM)
		elseif (sc[1] <= MAX_SCORE_PROB and sc[1] >= MIN_SCORE_PROB)
			then rspamd_plugins.fuzzy_check.learn(task, FUZZY_FLAG_PROB, FUZZY_WEIGHT_PROB)
		elseif (sc[1] <= MAX_SCORE_HAM and sc[1] >= MIN_SCORE_HAM)
			then rspamd_plugins.fuzzy_check.learn(task, FUZZY_FLAG_HAM, FUZZY_WEIGHT_HAM)
		else return end
	else return end
  end,
  type = 'idempotent'
  }
