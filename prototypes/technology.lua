data:extend(
	{
		{
			type = "technology",
			name = "distributed-chest",
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
				count = 50,	
				ingredients =
				{			  
				   {"automation-science-pack", 1}
				},
				{
				  {"logistic-science-pack", 0.5}
				},
				time = 5
			},
			prerequisites = {"advanced-electronics"},
			order = "c-a"
		}
	}
)