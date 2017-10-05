--[[

Inventory Plus+ for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Copyright (c) 2013 Zeg9 <dazeg9@gmail.com>
Source Code: https://github.com/Zeg9/minetest-inventory_plus
License: GPLv3

]]--

-- modify creative inventory homepage
local creative = rawget(_G, "creative") or rawget(_G, "creative_inventory")
if creative then
local old_homepage_name = sfinv.get_homepage_name
function sfinv.get_homepage_name(player)
	if creative.is_enabled_for(player:get_player_name()) then
		return "sfinv:crafting"
	else
		return old_homepage_name(player)
	end
end
end

-- modify sfinv crafting page
local sfinv = rawget(_G, "sfinv")
if sfinv then

-- create detached inventory for trash
local trashInv = minetest.create_detached_inventory("crafting_trash", {

	on_put = function(inv, toList, toIndex, stack, player)
		inv:set_stack(toList, toIndex, {})--ItemStack(nil))
		minetest.sound_play("default_cool_lava", {to_player=player_name, gain = 0.25})
	end
})

trashInv:set_size("main", 1)


sfinv.override_page("sfinv:crafting", {
		title = "Crafting",
		get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
		button[7.25,0;0.8,0.8;page_reload;@]
		tooltip[page_reload;Reload Inv++]
		listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]
		image[5.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
		image[0.075,1.6;0.8,0.8;creative_trash_icon.png]
		list[current_player;main;0,4.7;8,1;]
		list[current_player;craft;2.5,0.5;3,3;]
		listring[]
		list[detached:crafting_trash;main;0,1.5;1,1;]
		list[current_player;craftpreview;7,1.5;1,1;]
		listring[current_player;main]
		..default.gui_bg ..default.gui_bg_img ..default.gui_slots
		]], true)
	end
})

end

dofile(minetest.get_modpath("inventory_plus").."/invplusplus.lua")