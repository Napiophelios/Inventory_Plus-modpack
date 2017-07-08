-- Needed variables
local pvptable = {}

minetest.register_on_joinplayer(function(player)
	localname = player:get_player_name()
	pvptable[localname] = 0
	
		inventory_plus.register_button(player,"pvp","PvP")
		minetest.after(1,function()
			inventory_plus.set_inventory_formspec(player,inventory_plus.get_formspec(player, inventory_plus.default))
		end)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)

	localname = player:get_player_name()
	
	if fields.pvp then
		if pvptable[localname] == 0 then
		pvptable[localname] = 1
		minetest.chat_send_player(localname,
			"PvP was enabled for "..localname)
				player:hud_remove(pvpdisabled)
				pvpenabled = player:hud_add({
					hud_elem_type = "text",
					position = {x = 1, y = 0},
					offset = {x=-100, y = 20},
					scale = {x = 100, y = 100},
					text = "PvP is enabled for you!",
					number = 0xFF0000 -- Red
				})
		return
		else
		
		pvptable[localname] = 0
		
		minetest.chat_send_player(localname,
			"PvP was disabled for "..localname)
				player:hud_remove(pvpenabled)
		return
		end
	end
end)

if minetest.setting_getbool("enable_pvp") then
	if minetest.register_on_punchplayer then
		minetest.register_on_punchplayer(
			function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage, pvp)
			
			if not hitter:is_player() then
				return false
			end
			
			local localname = player:get_player_name()
			local hittername = hitter:get_player_name()
			
				if pvptable[localname] == 1 and pvptable[hittername] == 1 then
					return false
				else
					minetest.chat_send_player(localname,
					"The player "..hittername.." is trying to attack you.")
					minetest.chat_send_player(hittername,
					"The player "..localname.." does not have PvP activated.")
					return true
				end
		end)
	end
end