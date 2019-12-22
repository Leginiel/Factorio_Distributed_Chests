DistributedChestGroup = {chests = {}}
DistributedChestGroup.__index = DistributedChestGroup

function DistributedChestGroup:new()
	local obj = {}
	setmetatable(obj, DistributedChestGroup)
	obj.chests = {}
	
	return obj
end		  

function DistributedChestGroup:get_chests() 
	return self.chests
end

function DistributedChestGroup:min_distance(newChest)
	local minDistance = -1
	
	for index, chest in pairs(self.chests) do
		local distance = self:calculate_distance(chest, newChest)
		if minDistance == -1 then 
			minDistance = distance
		else 
			minDistance = math.min(minDistance, distance)
		end
	end
	
	return minDistance
end

function DistributedChestGroup:calculate_distance(chest, newChest) 
	return math.abs(chest.position["x"] - newChest.position["x"]) + math.abs(chest.position["y"] - newChest.position["y"])
end 

function DistributedChestGroup:add_chest(chest)
	table.insert(self.chests, chest)
end

function DistributedChestGroup:remove_chest_index(chestIndex)
	table.remove(self.chests, chestIndex)
end

function DistributedChestGroup:remove_chest(chestToRemove) 
	for index, chest in pairs(self.chests) do 
		if chest == chestToRemove then 
			self:remove_chest_index(index)
			break
		end
	end
	return DistributedChestGroup:need_new_group(chestToRemove)
end

function DistributedChestGroup:contains(searchChest)
	local result = false
	
	for index, chest in pairs(self.chests) do 
		result = (chest == searchChest) or result
	end
	return result
end

function DistributedChestGroup:need_new_group(removedChest)
	return #self:get_adjacant_chests(removedChest) > 1
end

function DistributedChestGroup:get_adjacant_chests(removedChest)
	local adjacantChests = {}
	
	for index, chest in pairs(self.chests) do
		if self:calculate_distance(chest, removedChest) == 1 then
			table.insert(adjacantChests, chest)
		end
	end
	return adjacantChests
end

function DistributedChestGroup:split(removedChest)
	local adjacantChests = self:get_adjacant_chests(removedChest)
	local newGroup = DistributedChestGroup:new()
	local movedChest = adjacantChests[0]
	
	newGroup:add_chest(movedChest)
	
	for index, chest in pairs(self.chests) do
		if self:min_distance(chest, movedChest) == 1 then
			newGroup:add_chest(movedChest)
			movedChest = chest
		end
	end
	for index, chest in pairs(newGroup.chests) do
		self:remove_chest(chest)
	end
	
	return newGroup
end

function DistributedChestGroup:merge(group)
	for index, chest in pairs(group.chests) do
		self:add_chest(chest)
	end
end

function DistributedChestGroup:get_contents()
	local content = {}
			
	for index, chest in pairs(self.chests) do 
		for item,count in pairs(self:get_chest_inventory(chest).get_contents()) do 
			if content[item] == nil then
				content[item] = count
			else 
				content[item] = content[item] + count;
			end
		end
	end
	
	return content
end

function DistributedChestGroup:get_chest_inventory(chest)
	return chest.get_inventory(defines.inventory.chest)
end

function DistributedChestGroup:distribute() 
	local content = self:get_contents()
	local usedItemCount = 0
	local lastChest = {}
	
	for item,count in pairs(content) do 
		local requiredItemCount = math.floor(count / #self.chests)

		usedItemCount = 0
	
		for index, chest in pairs(self.chests) do 
			local inventory = self:get_chest_inventory(chest)
			local itemStack = {item, requiredItemCount}
			local chestItemCount = inventory.get_item_count(item)
			if chestItemCount > requiredItemCount then
				inventory.remove({name = item, count = chestItemCount - requiredItemCount})
			elseif chestItemCount < requiredItemCount then
				local fillStack = {name = item, count = requiredItemCount - chestItemCount}
				if inventory.can_insert(fillStack) then
					inventory.insert(fillStack)
				end 
			end
			usedItemCount = usedItemCount + requiredItemCount			
			lastChest = chest
		end
		count = count - usedItemCount;
		
		if count > 0 and lastChest.can_insert({name = item,count =  count}) then
			lastChest.insert({name = item, count = count})
		end
	end
end