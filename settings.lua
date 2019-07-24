data:extend{
  {
    -- If trains can be manualy placed on tracks
    setting_type = "startup",
    name = "trainController-manual-placing-trains",
    type = "bool-setting",
    default_value = false,
    order = "trainController-b[manual-placing-trains]",
  },
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
