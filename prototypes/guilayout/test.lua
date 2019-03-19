require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "traincontroller", "horizontal", {
  style   = "frame_without_footer",
  caption = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}},
})

local guiTabs = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traincontroller-tab", {
  {name = "depoSelection", caption = "select depo", enabled = true},
  {name = "configuration", caption = "train configuration"},
})

--[[
local tabFrame = LSlib.gui.layout.addFrame(guiLayout, guiFrame, "tabFrame", "vertical", {
  style = "inside_deep_frame_for_tabs"
})

-- buttons
local tabButtonFlow = LSlib.gui.layout.addFlow(guiLayout, tabFrame, "tabFlow", "horizontal")
LSlib.gui.layout.addButton(guiLayout, tabButtonFlow, "button1")
LSlib.gui.layout.addButton(guiLayout, tabButtonFlow, "button2")

-- content
tabFrame = LSlib.gui.layout.addFrame(guiLayout, tabFrame, "tabFrame", "vertical")
]]

return guiLayout
