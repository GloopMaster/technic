-- LV Battery box and some other nodes...
local max_charge         = 6000 -- Set maximum charge for the device here
local max_charge_rate    = 100   -- Set maximum rate of charging
local max_discharge_rate = 200   -- Set maximum rate of discharging
local charge_step        = 100
local discharge_step     = 400


technic.register_power_tool("LV", "technic:battery",10000)
technic.register_power_tool("MV", "technic:red_energy_crystal",100000)
technic.register_power_tool("HV", "technic:green_energy_crystal",250000)
technic.register_power_tool("HV", "technic:blue_energy_crystal",500000)

minetest.register_craft({
	output = 'technic:battery',
	recipe = {
		{'default:wood', 'default:copper_ingot', 'default:wood'},
		{'default:wood', 'moreores:tin_ingot',   'default:wood'},
		{'default:wood', 'default:copper_ingot', 'default:wood'},
	}
})

minetest.register_tool("technic:battery", {
	description = "RE Battery",
	inventory_image = "technic_battery.png",
	tool_capabilities = {
		charge = 0,
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
})

minetest.register_craft({
	output = 'technic:lv_battery_box0',
	recipe = {
		{'technic:battery',     'default:wood',         'technic:battery'},
		{'technic:battery',     'default:copper_ingot', 'technic:battery'},
		{'default:steel_ingot', 'default:steel_ingot',  'default:steel_ingot'},
	}
})

technic.register_battery_box("LV", max_charge, max_charge_rate, max_discharge_rate, charge_step, discharge_step)

