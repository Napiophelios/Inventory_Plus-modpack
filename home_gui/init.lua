--[[
--
-- Home GUI for Minetest
--
-- Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
-- Source Code: https://github.com/cornernote/minetest-home_gui
-- License: BSD-3-Clause https://raw.github.com/cornernote/minetest-home_gui/master/LICENSE
--
--
-- This is a modified verson of Home Gui mod by TenPlus1
-- formspec edited by Napiophelios
--
]]--

-- Add Home GUI
if minetest.get_modpath("sethome") and sethome then
-- static spawn position
local statspawn = (minetest.setting_get_pos("static_spawnpoint") or {x = 0, y = 12, z = 0})
local home_gui = {}

-- get_formspec
home_gui.get_formspec = function(player)

	local formspec = "size[8,8.6]"
		.. default.gui_bg
		.. default.gui_bg_img
		.. default.gui_slots
		.. "button[0,0;2,0.5;main;Back]"
		.. "button_exit[0.5,2;2,0.5;home_gui_set;Set Home]"
		.. "button_exit[3,2;2,0.5;home_gui_go;Go Home]"
		.. "button_exit[5.5,2;2,0.5;home_gui_spawn;Spawn]"
  .."list[current_player;main;0,4.7;8,1;]"
  .."list[current_player;main;0,5.85;8,3;8]"

	local home = sethome.get( player:get_player_name() )

	if home then
		formspec = formspec
			.."label[2.15,3.35;Home set to:]"
			.."label[4.15,3.35;".. minetest.pos_to_string(vector.round(home)) .. "]"
	end

	return formspec
end

-- add inventory_plus page when player joins
minetest.register_on_joinplayer(function(player)
	inventory_plus.register_button(player,"home_gui","Home Pos")
end)

-- what to do when we press da buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local privs =  minetest.get_player_privs(player:get_player_name()).home
	if privs and fields.home_gui_set then
		sethome.set( player:get_player_name(), player:getpos() )
				inventory_plus.set_inventory_formspec(player, inventory_plus.get_formspec(player,"main"))
	end
	if privs and fields.home_gui_go then
		sethome.go( player:get_player_name() )
				inventory_plus.set_inventory_formspec(player, inventory_plus.get_formspec(player,"main"))
	end
	if privs and fields.home_gui_spawn then
		player:setpos(statspawn)
				inventory_plus.set_inventory_formspec(player, inventory_plus.get_formspec(player,"main"))
	end
	if fields.home_gui then
		inventory_plus.set_inventory_formspec(player, home_gui.get_formspec(player))
	end
end)

-- spawn command
minetest.register_chatcommand("spawn", {
	description = "Go to Spawn",
	privs = {home = true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		player:setpos(statspawn)
	end,
})
end