local M = {}

---@type ColorschemeShuffle.Config
local config = {
	deck = nil,
	blacklist = {},
	shuffle_events = {},
	notify = true,
}

local lib = require("colorscheme-shuffle.lib")

-- Register a colorscheme for the picker
function M.append_deck(cs)
	config.deck[#config.deck + 1] = config.blacklist[cs] and nil or cs
end

-- Register a colorscheme to ignore
function M.append_blacklist(cs)
	config.blacklist[cs] = true
	-- Remove the colorscheme if it's in the deck
	config.deck = lib.remove_blacklisted_colorschemes(config.deck, { [cs] = true })
end

-- Index in the list that we read from, increments each time we go to the "next" colorscheme
local idx = 0

--- Go to the next random colorscheme in the deck
---@param deck (string[]|nil)?
---@param notify boolean?
function M.next(deck, notify)
	deck = deck or config.deck
	notify = notify or config.notify
	-- get current colorscheme
	local old_cs = vim.api.nvim_exec2("colorscheme", { output = true }).output
	local new_cs = old_cs
	if #deck == 0 then
		vim.notify("colorscheme-shuffle.nvim: attempted shuffle with deck size zero", vim.log.levels.WARN, {})
		return
	end
	-- track iterations
	local i = 0
	-- pick a colorscheme that's different from the current one
	while new_cs == old_cs do
		-- move idx up by one, wrapping at the end of `colorschemes`
		idx = (idx + 1) % #deck
		idx = idx == 0 and #deck or idx
		-- shuffle the list when we reach the end
		if idx == 1 then
			lib.shuffle_inplace(deck)
			-- vim.notify('shuffled colorschemes', vim.log.levels.DEBUG, {})
		end
		assert(deck)
		new_cs = deck[idx]
		-- Guard against infinite loops
		if i == #deck then
			vim.notify(
				"colorscheme-shuffle.nvim: Couldn't find a different colorscheme to switch to after "
					.. tostring(i)
					.. " iterations (deck size: "
					.. tostring(#deck)
					.. ")\ndeck:"
					.. vim.inspect(config.deck),
				vim.log.levels.ERROR,
				{}
			)
			break
		end
		i = i + 1
	end
	-- set the new colorscheme
	vim.cmd.colorscheme(new_cs)
	if notify then
		vim.notify("colorscheme: " .. (new_cs or ""), vim.log.levels.INFO, {})
	end
end

--- Setup the plugin, optionally performing the shuffle_events option
---@param user_config ColorschemeShuffle.UserConfig
function M.setup(user_config)
	config = vim.tbl_deep_extend("force", config, user_config)

	-- default to all colorschemes
	config.deck = (config.deck or {}) == {} and {} or lib.get_available_colorschemes()
	lib.shuffle_inplace(config.deck)
	-- build the blacklist
	config.blacklist = lib.list_values_to_keys(config.blacklist)
	-- apply the blacklist
	config.deck = lib.remove_blacklisted_colorschemes(config.deck, config.blacklist)

	if config.shuffle_events then
		local augroup = vim.api.nvim_create_augroup("colorscheme-shuffle.nvim", {})
		for key, value in pairs(config.shuffle_events) do
			if type(key) == "number" then
				if value == "ON_LOAD" then
					-- Special event: load instantly
					M.next(config.deck, false)
				else
					print("Event key: ", key)
					vim.api.nvim_create_autocmd(value, {
						group = augroup,
						callback = function()
							M.next()
						end,
					})
				end
			elseif type(key) == "string" then
				vim.api.nvim_create_autocmd(key, {
					pattern = value,
					group = augroup,
					callback = function()
						M.next()
					end,
				})
			end
		end
	end
end

return M
