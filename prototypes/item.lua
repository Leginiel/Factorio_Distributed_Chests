data:extend(
	{
		{
			type = "item",
			name = "distributed-chest",
			icon = "__Distributed-Chests__/graphics/distributed-chest.png",
			icon_size = 32,
			subgroup = "storage",
			order = "a[items]-c[distributed-chest]",
			place_result = "distributed-chest",
			stack_size = 50
		}
	}
)

local recipe = table.deepcopy(data.raw.recipe["steel-chest"])
recipe.enabled = true
recipe.name = "distributed-chest"
recipe.ingredients = {{"advanced-circuit",4},{"fast-inserter",4}, {"distributed-chest", 1}}
recipe.result = "distributed-chest"

data:extend({recipe})