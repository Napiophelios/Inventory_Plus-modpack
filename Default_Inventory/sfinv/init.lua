dofile(minetest.get_modpath("sfinv") .. "/api.lua")


-- Create the trash field
local trash = minetest.create_detached_inventory("crafting_trash", {
	allow_put = function(inv, listname, index, stack, player)
		return stack:get_count()
	end,
	on_put = function(inv, listname, player)
		inv:set_list(listname, {})
		minetest.sound_play("crafting_trash", {to_player=player_name, gain = 0.25})
	end,
})
trash:set_size("main", 1)

--[[if minetest.setting_getbool("enable_damage") then
	sfinv.register_page("sfinv:crafting", {
		title = "Crafting",
		get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
		listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]
		image[5.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
		image[0.075,1.6;0.8,0.8;crafting_trash_icon.png]
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

else
--]]

sfinv.register_page("sfinv:crafting", {
		title = "Crafting",
		get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
		button[7.25,0;0.8,0.8;page_reload;@]
		tooltip[page_reload;Reload Inv++]
		listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]
		image[5.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
		image[0.075,1.6;0.8,0.8;crafting_trash_icon.png]
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

--end
