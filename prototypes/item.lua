data:extend(
	{
		{
			type = "item",
			name = "distributed-chest",
			icon = "__Distributed-Chests__/graphics/hr-distributed-chest.png",
			subgroup = "storage",
			order = "a[items]-c[distributed-chest]",
			place_result = "distributed-chest",
			width = 64,
			height = 80,
			scale = 0.5,
			icon_size = 64,
			stack_size = 50,
			hr_version =
          {
            filename = "__Distributed-Chests__/graphics/hr-distributed-chest.png",
            priority = "extra-high",
            width = 64,
            height = 80,
            shift = util.by_pixel(-0.25, -0.5),
            scale = 0.5
          }
		}
	}
)

local recipe = table.deepcopy(data.raw.recipe["steel-chest"])
recipe.enabled = true
recipe.name = "distributed-chest"
recipe.ingredients = {{"advanced-circuit",4},{"fast-inserter",4}, {"steel-chest", 1}}
recipe.result = "distributed-chest"

data:extend({recipe})