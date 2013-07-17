
local max_charge         = 1500000
local max_charge_rate    = 300000
local max_discharge_rate = 500000
local charge_step        = 10000
local discharge_step     = 40000

-- HV battery box
minetest.register_craft({
	output = 'technic:hv_battery_box0 1',
	recipe = {
		{'technic:mv_battery_box0', 'technic:mv_battery_box0', 'technic:mv_battery_box0'},
		{'technic:mv_battery_box0', 'technic:hv_transformer',  'technic:mv_battery_box0'},
		{'',                        'technic:hv_cable0',       ''},
	}
})

technic.register_battery_box("HV", max_charge, max_charge_rate, max_discharge_rate, charge_step, discharge_step)

