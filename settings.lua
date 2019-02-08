data:extend{
  {
    -- Ticks between builder updates
    setting_type = "runtime-global",
    name = "trainController-tickRate", -- in ticks
    type = "int-setting",
    minimum_value = 1,
    maximum_value = 60,
    default_value = 5,
    order = "trainController-a[tickRate]",
  },
}
