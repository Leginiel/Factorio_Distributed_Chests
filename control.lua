require "distributedChestGroups"

script.on_load(function()
		for index, group in pairs(global.distributedChestGroups) do
			setmetatable(group, DistributedChestGroup)
		end
		registerEvents()
end)

script.on_init(function()
	if global.distributedChestGroups == nil then
		global.distributedChestGroups = {}	
	end
  registerEvents()
end)

function registerEvents() 
	script.on_event(defines.events.on_built_entity, builtEntity)
	script.on_event(defines.events.on_robot_built_entity, builtEntity)
	script.on_event(defines.events.on_player_mined_entity, removedEntity)
	script.on_event(defines.events.on_robot_mined_entity, removedEntity)
	script.on_event(defines.events.on_entity_died, removedEntity)	
	script.on_event(defines.events.on_tick, ticker)
end

function builtEntity(event)
	local chest
	local group
	local adjacant_groups		
	
	if event.created_entity.name == "distributed-chest" then
		chest = event.created_entity
		adjacant_groups = adjacant_distributed_chest_groups(chest)
		if #adjacant_groups > 1 then
			adjacant_groups[1]:add_chest(chest)
			adjacant_groups[1]:merge(adjacant_groups[2])
			remove_group(adjacant_groups[2])
		else
			group = find_distributed_chest_group(chest)
			group:add_chest(chest)
		end
		group:distribute()		
	end
end

function removedEntity(event)
	local chest
	if event.entity.name == "distributed-chest" then
		chest = event.entity
		group = find_distributed_chest_group_with_chest(chest)
		group:remove_chest(chest)
		
		if group:need_new_group(chest) then 
			table.insert(global.distributedChestGroups, group:split(chest))
		end
		
		if #group.chests == 0 then
			remove_group(group)
		end
	end
	
end

function find_distributed_chest_group_with_chest(chest) 
	for index, group in pairs(global.distributedChestGroups) do 
		if group:contains(chest) then
			return group
		end
	end
		
	return nil
end

function adjacant_distributed_chest_groups(newChest)
	local groups = {}
	
	for index, group in pairs(global.distributedChestGroups) do 
		if group:min_distance(newChest) == 1 then 
			table.insert(groups, group)
		end
	end
	return groups
end

function find_distributed_chest_group(newChest) 
	local groupFound = false
	local group = nil

	for index, group in pairs(global.distributedChestGroups) do 
		if group:min_distance(newChest) == 1 then 
			return group;
		end
	end

	if not groupFound then
		group = DistributedChestGroup:new()
		table.insert(global.distributedChestGroups, group)
	end
		
	return group
end

function remove_group(groupToRemove) 
	for index, group in pairs(global.distributedChestGroups) do 
		if group == groupToRemove then 
			table.remove(global.distributedChestGroups, index)
			break;
		end
	end
end

function ticker()
   if global.distributedChestGroups ~= nil then
      if game.tick % 60 == 0 then
         update_chest_groups()
      end
   else
      script.on_event(defines.events.on_tick, nil)
   end
end

function update_chest_groups() 
	if global.distributedChestGroups ~= nil then
		for index, group in pairs(global.distributedChestGroups) do
			group:distribute()
		end
	end
end