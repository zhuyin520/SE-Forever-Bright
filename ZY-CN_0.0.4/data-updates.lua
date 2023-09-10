require("config" )

function update_lights( lights, add_omni_full )
	local has_omni_light = false
	
	if lights ~= nil then
		for _, light in pairs(lights) do
			if type(light) == "table" then
				if light.minimum_darkness ~= nil then light.minimum_darkness = my_light_minimum_darkness end
				--如果light.type(灯光类型)和light.type==“定向”，则
				if light.type == "oriented" then
					--播放器或车辆的锥形灯
					if light.intensity then light.intensity = my_light_cone_intensity end
				elseif light.add_perspective ~= nil then
					--播放器或车辆的锥形灯
				else
					--全向灯
					if light.intensity then light.intensity = my_light_intensity end
					if light.size then light.size = my_light_size end
					has_omni_light = true
				end
			else
				has_omni_light = true
			end
		end
	
		--playv的锥形灯——如果没有全向灯，则添加一个
		if not has_omni_light then
			table.insert(lights,
				{
					minimum_darkness = my_light_minimum_darkness,  
					intensity = my_light_intensity * (add_omni_full and 1 or 0.5), 
					size = add_omni_full and my_light_size or 20, 
				}
			)
		end
	end
end

if my_light_custom then
	-- 更新灯光 (data.raw.player.player.light, true )
	
	for _, v in pairs(data.raw.character) do
		if v.light == nil then v.light = {} end
		update_lights(v.light, true )
	end

	for _, v in pairs(data.raw.car) do
		update_lights(v.light, true)
	end
	
	for _, v in pairs(data.raw.locomotive) do
		update_lights(v.front_light, true)
		update_lights(v.stand_by_light, my_light_locomotive_still )
	end
end
    


	

