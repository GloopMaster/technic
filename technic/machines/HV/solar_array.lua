-- The high voltage solar array is an assembly of medium voltage arrays.
-- The assembly can deliver high voltage levels and is a 20% less efficient
-- compared to 5 individual medium voltage arrays due to losses in the transformer.
-- However high voltage is supplied.
-- Solar arrays are not able to store large amounts of energy.

minetest.register_craft({
	output = 'technic:solar_array_hv 1',
	recipe = {
		{'technic:solar_array_mv', 'technic:solar_array_mv',  'technic:solar_array_mv'},
		{'technic:solar_array_mv', 'technic:hv_transformer',  'technic:solar_array_mv'},
		{'default:steel_ingot',    'technic:hv_cable0',       'default:steel_ingot'},
	}
})

technic.register_solar_array({tier="HV", power=100})

