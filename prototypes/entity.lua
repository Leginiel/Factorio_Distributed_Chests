
local distributedChest = table.deepcopy(data.raw.container["steel-chest"])

distributedChest.name = "distributed-chest"
distributedChest.order = "d-i-s"
distributedChest.minable = {mining_time = 0.2, result = "distributed-chest"}
distributedChest.icons= {
   {
      icon="__Distributed-Chests__/graphics/distributed-chest.png"
   },
}
distributedChest.picture =
    {
      layers =
      {
        {
          filename = "__Distributed-Chests__/graphics/distributed-chest.png",
          priority = "extra-high",
          width = 64,
          height = 80,
          shift = util.by_pixel(0, -0.5),
        },
        {
          filename = "__Distributed-Chests__/graphics/distributed-chest-shadow.png",
          priority = "extra-high",
          width = 110,
          height = 46,
          shift = util.by_pixel(12, 7.5),
          draw_as_shadow = true,
        }
      }
    }

data:extend({distributedChest})