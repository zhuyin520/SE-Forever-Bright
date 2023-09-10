--data-updates.lua

require("config")

function update_lights(lights, add_omni_full)
	local has_omni_light = false
	
	if lights ~= nil then
		for _, light in pairs(lights) do
			if type(light) == "table" then
				-- 移除黑暗级别检查
				if light.type == "oriented" then
					if light.intensity then light.intensity = my_light_cone_intensity end
				elseif light.add_perspective ~= nil then
					-- 播放器或车辆的锥形灯
				else
					-- 全向灯
					if light.intensity then light.intensity = my_light_intensity end
					if light.size then light.size = my_light_size end
					has_omni_light = true
				end
			else
				has_omni_light = true
			end
		end
	
		-- 如果没有全向灯，则添加一个
		if not has_omni_light then
			table.insert(lights,
				{
					-- 移除黑暗级别检查
					intensity = my_light_intensity * (add_omni_full and 1 or 0.5), 
					size = add_omni_full and my_light_size or 20, 
				}
			)
		end
	end
end

if my_light_custom then
	for _, v in pairs(data.raw.character) do
		if v.light == nil then v.light = {} end
		update_lights(v.light, true)
		
		-- 在进入汽车时，人物灯光也是开启的状态
		if v.mining_speed and v.mining_speed > 0 then
			update_lights(v.light, true)
		end
		
		-- 在进入蜘蛛车辆时，人物灯光也是开启的状态
		if my_light_spider_vehicle and v.spider_engine and v.spider_engine.speed > 0 then
			update_lights(v.light, true)
		end

		-- 在驾驶状态下，人物灯光也是开启的状态
		if my_light_driving and v.driving then
			update_lights(v.light, true)
		end
	end

	for _, v in pairs(data.raw.car) do
		update_lights(v.light, true)
	end
	
	for _, v in pairs(data.raw.locomotive) do
		update_lights(v.front_light, true)
		update_lights(v.stand_by_light, my_light_locomotive_still)
	end
end
