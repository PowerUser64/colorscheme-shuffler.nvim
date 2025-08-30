local M = {}

--- Remove unwanted colorschemes from the list
---@param colorschemes string[]
---@param blacklist table
---@return string[] colorschemes the updated colorscheme list
function M.remove_blacklisted_colorschemes(colorschemes, blacklist)
	local ret = {}
	for _, cs in ipairs(colorschemes) do
		if not blacklist[cs] then
			ret[#ret + 1] = cs
		end
	end
	return ret
end

-- Get all colorschemes
function M.get_available_colorschemes()
	local ret = vim.fn.getcompletion("", "color")
	-- ret = list_values_to_keys(ret)
	return ret
end

-- Shuffle a list
function M.shuffle_inplace(x)
	math.randomseed(os.time())
	-- credit: Fisher-Yates https://www.programming-idioms.org/idiom/10/shuffle-a-list/2019/lua
	for i = #x, 2, -1 do
		local j = math.random(i)
		x[i], x[j] = x[j], x[i]
	end
end

-- take an array and transform the values into keys that are assigned to 'true'
function M.list_values_to_keys(t)
	local ret = {}
	for _, value in ipairs(t) do
		ret[value] = true
	end
	return ret
end

return M
