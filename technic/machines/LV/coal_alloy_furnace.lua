
-- Coal driven alloy furnace. This uses no EUs:


minetest.register_craft({
	output = 'technic:coal_alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '',              'default:brick'},
		{'default:brick', 'default:brick', 'default:brick'},
	}
})

minetest.register_node("technic:coal_alloy_furnace", {
	description = "Alloy Furnace",
	tiles = {"technic_coal_alloy_furnace_top.png", "technic_coal_alloy_furnace_bottom.png", "technic_coal_alloy_furnace_side.png",
		"technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", coal_alloy_furnace_formspec)
		meta:set_string("infotext", "Alloy Furnace")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("src2", 1)
		inv:set_size("dst", 4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not (inv:is_empty("fuel") or inv:is_empty("dst") or inv:is_empty("src") or inv:is_empty("src2") )then
			return false
			end
		return true
	end,
})

minetest.register_node("technic:coal_alloy_furnace_active", {
	description = "Alloy Furnace",
	tiles = {"technic_coal_alloy_furnace_top.png", "technic_coal_alloy_furnace_bottom.png", "technic_coal_alloy_furnace_side.png",
	         "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:coal_alloy_furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not (inv:is_empty("fuel") or inv:is_empty("dst") or
			inv:is_empty("src") or inv:is_empty("src2")) then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:coal_alloy_furnace", "technic:coal_alloy_furnace_active"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local inv    = meta:get_inventory()
		local recipe = nil
		local formspec =
			"size[8,9]"..
			"label[0,0;Alloy Furnace]"..
			"image[2,2;1,1;default_furnace_fire_bg.png]"..
			"list[current_name;fuel;2,3;1,1;]"..
			"list[current_name;src;2,1;1,1;]"..
			"list[current_name;src2;3,1;1,1;]"..
			"list[current_name;dst;5,1;2,2;]"..
			"list[current_player;main;0,5;8,4;]"

		for i, name in pairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"}) do
			if not meta:get_float(name) then
				meta:set_float(name, 0.0)
			end
		end

		-- Get what to cook if anything
		local srcstack = inv:get_stack("src", 1)
		if srcstack then
			src_item1 = srcstack:to_table()
		end

		local src2stack = inv:get_stack("src2", 1)
		if src2stack then
			src_item2 = src2stack:to_table()
		end

		if src_item1 and src_item2 then
			recipe = technic.get_alloy_recipe(src_item1.name, src_item2.name)
		end

		local was_active = false

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_int("fuel_time", meta:get_int("fuel_time") + 1)
			if recipe and
			   recipe.input[1].count <= src_item1.count and
			   recipe.input[2].count <= src_item2.count then
				meta:set_int("src_time", meta:get_int("src_time") + 1)
				if meta:get_int("src_time") == 6 then
					-- check if there's room for output in "dst" list
					local dst_stack = ItemStack(recipe.output)
					if inv:room_for_item("dst", dst_stack) then
						srcstack:take_item(recipe.input[1].count)
						inv:set_stack("src", 1, srcstack)
						src2stack:take_item(recipe.input[2].count)
						inv:set_stack("src2", 1, src2stack)
						inv:add_item("dst", dst_stack)
					end
					meta:set_int("src_time", 0)
				end
			else
				meta:set_int("src_time", 0)
			end
		end

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext","Furnace active: "..percent.."%")
			hacky_swap_node(pos, "technic:coal_alloy_furnace_active")
			meta:set_string("formspec",
					"size[8,9]"..
					"label[0,0;Electric Alloy Furnace]"..
					"image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
					(100-percent)..":default_furnace_fire_fg.png]"..
					"list[current_name;fuel;2,3;1,1;]"..
					"list[current_name;src;2,1;1,1;]"..
					"list[current_name;src2;3,1;1,1;]"..
					"list[current_name;dst;5,1;2,2;]"..
					"list[current_player;main;0,5;8,4;]")
			return
		end

		-- FIXME: Make this look more like the electrical version.
		-- This code refetches the recipe to see if it can be done again after the iteration
		srcstack = inv:get_stack("src", 1)
		if srcstack then src_item1=srcstack:to_table() end
		srcstack = inv:get_stack("src2", 1)
		if srcstack then src_item2=srcstack:to_table() end
		if src_item1 and src_item2 then
			recipe = technic.get_alloy_recipe(src_item1.name, src_item2.name)
		end

		if recipe and
		   recipe.input[1].count <= src_item1.count and
		   recipe.input[2].count <= src_item2.count then
			if was_active then
				meta:set_string("infotext", "Furnace is empty")
				hacky_swap_node(pos, "technic:coal_alloy_furnace")
				meta:set_string("formspec", formspec)
			end
			return
		end

		-- Next take a hard look at the fuel situation
		local fuel = nil
		local fuellist = inv:get_list("fuel")

		if fuellist then
			fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
			meta:set_string("infotext", "Furnace out of fuel")
			hacky_swap_node(pos, "technic:coal_alloy_furnace")
			meta:set_string("formspec", formspec)
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)

		local stack = inv:get_stack("fuel", 1)
		stack:take_item()
		inv:set_stack("fuel", 1, stack)
	end,
})

