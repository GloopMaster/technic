-- MV Battery box

local max_charge         = 300000  -- Set maximum charge for the device here
local max_charge_rate    = 20000   -- Set maximum rate of charging
local max_discharge_rate = 30000   -- Set maximum rate of discharging
local charge_step        = 2000
local discharge_step     = 8000


minetest.register_craft({
	output = 'technic:mv_battery_box0',
	recipe = {
		{'technic:lv_battery_box0', 'technic:lv_battery_box0', 'technic:lv_battery_box0'},
		{'technic:lv_battery_box0', 'technic:mv_transformer',  'technic:lv_battery_box0'},
		{'',                        'technic:mv_cable0',       ''},
	}
})

technic.register_battery_box("MV", max_charge, max_charge_rate, max_discharge_rate, charge_step, discharge_step)

