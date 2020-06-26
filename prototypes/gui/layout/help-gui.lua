
local guiLayout = LSlib.gui.layout.create("center")

local guiFlow = LSlib.gui.layout.addFlow(guiLayout, "root", "trainConstructionSite-help-gui", "horizontal", {
  style = "trainConstructionSite_help_contentFlow", -- no padding
})
local guiToCName     = "trainConstructionSite-help-toc"
local guiContentName = "trainConstructionSite-help-content"


--------------------------------------------------------------------------------
-- ToC                                                                        --
--------------------------------------------------------------------------------
local guiToC_frame = LSlib.gui.layout.addFrame(guiLayout, guiFlow, guiToCName.."-frame", "vertical", {
  caption = "Help menu",
  style   = "frame_with_even_small_even_paddings",
})
local guiToC = LSlib.gui.layout.addScrollPane(guiLayout, guiToC_frame, guiToCName, {
  style = "trainConstructionSite_help_scrollpane",
  horizontal_scroll_policy = "never",
  vertical_scroll_policy   = "auto" ,
})

-- footer --
local guiToCFooter = LSlib.gui.layout.addFlow(guiLayout, guiToC_frame, guiToCName.."-footer-flow", "horizontal", {
  style = "trainConstructionSite_help_ToC_footer_flow",
})
LSlib.gui.layout.addButton(guiLayout, guiToCFooter, "trainConstructionSite-help-gui-quit", {
  caption = "Close",
  style   = "back_button",
})
LSlib.gui.layout.addFrame(guiLayout, guiToCFooter, guiToCName.."-button-filler", "vertical", {
  style = "LSlib_default_footer_filler",
  ignored_by_interaction = true,
})


-- Content ---------------------------------------------------------------------
local function addFooter(layoutTable, parentPath, disableButton)
  local footerFlow = LSlib.gui.layout.addFlow(layoutTable, parentPath, guiContentName.."-footer-flow", "horizontal", {
    style = "LSlib_default_footer",
  })
  LSlib.gui.layout.addButton(guiLayout, footerFlow, guiContentName.."-previous", {
    caption = "Previous",
    style   = "back_button",
    enabled = ((not disableButton) or (disableButton ~= "previous")) and true or false,
  })
  LSlib.gui.layout.addFrame(guiLayout, footerFlow, guiContentName.."-footer-filler", "vertical", {
    style = "LSlib_default_footer_filler",
    ignored_by_interaction = true,
  })
  LSlib.gui.layout.addButton(guiLayout, footerFlow, guiContentName.."-next", {
    caption = "Next",
    style   = "forward_button",
    enabled = ((not disableButton) or (disableButton ~= "next")) and true or false,
  })
end


--------------------------------------------------------------------------------
-- Introduction                                                               --
--------------------------------------------------------------------------------
local introductionName = "-introduction"
LSlib.gui.layout.addButton(guiLayout, guiToC, guiToCName..introductionName, {
  caption = {"gui-help.introduction"},
  style   = "trainConstructionSite_help_tocButton",
})
introductionName = guiContentName..introductionName
local introductionFrame = LSlib.gui.layout.addFrame(guiLayout, guiFlow, introductionName, "vertical", {
  caption = {"gui-help.introduction"},
  style   = "frame_with_even_small_even_paddings",
})
local introduction = LSlib.gui.layout.addScrollPane(guiLayout, introductionFrame, introductionName.."-scrollPane", {
  style = "trainConstructionSite_help_scrollpane",
  horizontal_scroll_policy = "never",
  vertical_scroll_policy   = "always",
})


LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label1", {
  caption = {"gui-help.introduction-1"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label2", {
  caption = {"gui-help.introduction-2"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label3", {
  caption = {"gui-help.introduction-3"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label4", {
  caption = {"gui-help.introduction-4"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSprite(guiLayout, introduction, introductionName.."-sprite1", {
  sprite = introductionName.."-sprite1",
  style  = introductionName.."-sprite1",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label5", {
  caption = {"gui-help.introduction-5"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label6", {
  caption = {"gui-help.introduction-6"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
--[[LSlib.gui.layout.addLabel(guiLayout, introduction, introductionName.."-label7", {
  --TODO: add checkbox to disable button in top left corner
  caption = {"gui-help.introduction-7"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})]]


addFooter(guiLayout, introductionFrame, "previous")



-------------------------------------------------------------------------
-- Traindepot                                                                 --
--------------------------------------------------------------------------------
local traindepotName = "-traindepot"
LSlib.gui.layout.addButton(guiLayout, guiToC, guiToCName..traindepotName, {
  caption = {"item-name.traindepot"},
  style   = "trainConstructionSite_help_tocButton",
})
traindepotName = guiContentName..traindepotName
local traindepotFrame = LSlib.gui.layout.addFrame(guiLayout, guiFlow, traindepotName, "vertical", {
  caption = {"item-name.traindepot"},
  style   = "frame_with_even_small_even_paddings",
})
local traindepot = LSlib.gui.layout.addScrollPane(guiLayout, traindepotFrame, traindepotName.."-scrollPane", {
 style = "trainConstructionSite_help_scrollpane",
 horizontal_scroll_policy = "never",
 vertical_scroll_policy   = "always",
})


LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-title1", {
  caption = {"gui-help.traindepot-h1"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl1", {
  caption = {"gui-help.traindepot-1"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSprite(guiLayout, traindepot, traindepotName.."-sprite1", {
  sprite = traindepotName.."-sprite1",
  style  = traindepotName.."-sprite1",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl2", {
  caption = {"gui-help.traindepot-2"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})

LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-title2", {
  caption = {"gui-help.traindepot-h2"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl3", {
  caption = {"gui-help.traindepot-3"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl4", {
  caption = {"gui-help.traindepot-4"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl5", {
  caption = {"gui-help.traindepot-5"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})

LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-title3", {
  caption = {"gui-help.traindepot-h3"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl6", {
  caption = {"gui-help.traindepot-6"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traindepot, traindepotName.."-lbl7", {
  caption = {"gui-help.traindepot-7"},
  style = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})


addFooter(guiLayout, traindepotFrame)



--------------------------------------------------------------------------------
-- trainbuilder                                                               --
--------------------------------------------------------------------------------
local trainbuilderName = "-trainbuilder"
LSlib.gui.layout.addButton(guiLayout, guiToC, guiToCName..trainbuilderName, {
  caption = {"item-name.trainassembly"},
  style   = "trainConstructionSite_help_tocButton",
})
trainbuilderName = guiContentName..trainbuilderName
local trainbuilderFrame = LSlib.gui.layout.addFrame(guiLayout, guiFlow, trainbuilderName, "vertical", {
  caption = {"item-name.trainassembly"},
  style   = "frame_with_even_small_even_paddings",
})
local trainbuilder = LSlib.gui.layout.addScrollPane(guiLayout, trainbuilderFrame, trainbuilderName.."-scrollPane", {
 style = "trainConstructionSite_help_scrollpane",
 horizontal_scroll_policy = "never",
 vertical_scroll_policy   = "always",
})


LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-title1", {
  caption = {"gui-help.trainassembly-h1"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl1", {
  caption = {"gui-help.trainassembly-1"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})

LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-title2", {
  caption = {"gui-help.trainassembly-h2"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl2", {
  caption = {"gui-help.trainassembly-2"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSprite(guiLayout, trainbuilder, trainbuilderName.."-sprite1", {
  sprite = trainbuilderName.."-sprite1",
  style  = trainbuilderName.."-sprite1",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl3", {
  caption = {"gui-help.trainassembly-3"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl4", {
  caption = {"gui-help.trainassembly-4"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})

LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-title3", {
  caption = {"gui-help.trainassembly-h3"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl5", {
  caption = {"gui-help.trainassembly-5"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl6", {
  caption = {"gui-help.trainassembly-6"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl7", {
  caption = {"gui-help.trainassembly-7"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSprite(guiLayout, trainbuilder, trainbuilderName.."-sprite2", {
  sprite = trainbuilderName.."-sprite2",
  style  = trainbuilderName.."-sprite2",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl8", {
  caption = {"gui-help.trainassembly-8"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, trainbuilder, trainbuilderName.."-lbl9", {
  caption = {"gui-help.trainassembly-9"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})


addFooter(guiLayout, trainbuilderFrame)



--------------------------------------------------------------------------------
-- Trainbuilder controller                                                    --
--------------------------------------------------------------------------------
local traincontrollerName = "-traincontroller"
LSlib.gui.layout.addButton(guiLayout, guiToC, guiToCName..traincontrollerName, {
  caption = {"item-name.traincontroller", {"item-name.trainassembly"}},
  style   = "trainConstructionSite_help_tocButton",
})
traincontrollerName = guiContentName..traincontrollerName
local traincontrollerFrame = LSlib.gui.layout.addFrame(guiLayout, guiFlow, traincontrollerName, "vertical", {
  caption = {"item-name.traincontroller", {"item-name.trainassembly"}},
  style   = "frame_with_even_small_even_paddings",
})
local traincontroller = LSlib.gui.layout.addScrollPane(guiLayout, traincontrollerFrame, traincontrollerName.."-scrollPane", {
 style = "trainConstructionSite_help_scrollpane",
 horizontal_scroll_policy = "never",
 vertical_scroll_policy   = "always",
})


LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-title1", {
  caption = {"gui-help.traincontroller-h1"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl1", {
  caption = {"gui-help.traincontroller-1"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSprite(guiLayout, traincontroller, traincontrollerName.."-sprite1", {
  sprite = traincontrollerName.."-sprite1",
  style  = traincontrollerName.."-sprite1",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl2", {
  caption = {"gui-help.traincontroller-2"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})

LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-title2", {
  caption = {"gui-help.traincontroller-h2"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl3", {
  caption = {"gui-help.traincontroller-3"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl4", {
  caption = {"gui-help.traincontroller-4"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl5", {
  caption = {"gui-help.traincontroller-5"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl6", {
  caption = {"gui-help.traincontroller-6"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})

LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-title3", {
  caption = {"gui-help.traincontroller-h3"},
  style = "trainConstructionSite_help_contentHeader",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl7", {
  caption = {"gui-help.traincontroller-7"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSprite(guiLayout, traincontroller, traincontrollerName.."-sprite2", {
  sprite = traincontrollerName.."-sprite2",
  style  = traincontrollerName.."-sprite2",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, traincontroller, traincontrollerName.."-lbl8", {
  caption = {"gui-help.traincontroller-8"},
  style   = "trainConstructionSite_help_contentText",
  ignored_by_interaction = true,
})


addFooter(guiLayout, traincontrollerFrame, "next")



----------------
return guiLayout
