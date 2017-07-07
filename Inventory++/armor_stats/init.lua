-- armor stats hud mod
--
-- this draws a statbar for armor above the breath bar for whatever
-- armor the players are wearing
--
-- license: WTFPL

local stats = {}
local update_interval = 1.0
local is_armor = minetest.get_modpath("3d_armor") ~= nil
local shields = minetest.get_modpath("shields") ~= nil

if minetest.setting_getbool("enable_damage") and is_armor then
	minetest.register_on_joinplayer(function(player)
		local name = player:get_player_name()
		stats[name] = {}
		local id = player:hud_add({
			name = "armor_stats",
			hud_elem_type = "statbar",
			position = {x = 0.5, y = 1},
			size = {x = 24, y = 24},
			text = "hud_armor_fg.png",
			number = 0,
   alignment = {x = -1, y = -1},
			offset = { x=-325, y = -116},
			max = 0,
		})
		stats[name].hud_id = id
		stats[name].level = 0
	end)
end

-- just poll each interval (1s default)

local function update_stats()
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		if name and stats[name] then
			local level = 0
			local max = 63 -- full diamond armor
			if shields then max = 84.14 end -- + diamond shield

			local def = armor.def
			if def[name] and def[name].level then
				level = def[name].level
			end

			level = math.floor(20.0 * math.min(1.0, level / max))

			-- wait for the value to *visibly* change before updating
			-- (hud_change more often than that is just redundant)
			if stats[name].level ~= level then
				stats[name].level = level
				player:hud_change(stats[name].hud_id, "number", level)
			end
		end
	end

	minetest.after(update_interval, update_stats)
end

if is_armor then
	minetest.after(update_interval, update_stats)
end
