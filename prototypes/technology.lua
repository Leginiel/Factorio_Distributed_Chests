data:extend(
	{
		{
			type = "technology",
			name = "distributed-chests",
			icon_size = 128,
			icon = "__Distributed-Chests__/graphics/distributed-chest-technology.png",
			effects =
			{
			  {
				type = "unlock-recipe",
				recipe = "distributed-chest"
			  }
			},
			unit =
			{
				count = 25,	
				ingredients =
				{			  
					{"automation-science-pack", 2},
					{"logistic-science-pack", 1}
				},
				time = 5
			},
			prerequisites = {"advanced-electronics"},
			order = "c-a"
		}
	}
)