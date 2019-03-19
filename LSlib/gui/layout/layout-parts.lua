require "util"

if not (LSlib and LSlib.gui and LSlib.gui.layout) then require "layout" else
  require "layout-elements"

  function LSlib.gui.layout.addTabs(layoutTable, parentPath, tabName, tabPages)

    -- frame for the tab
    local tabFrame = LSlib.gui.layout.addFrame(layoutTable, parentPath, tabName, "vertical", {
      style = "inside_deep_frame_for_tabs"
    })

    -- tabflows
    local tabButtonFlow  = LSlib.gui.layout.addFlow(layoutTable, tabFrame, tabName.."buttons", "horizontal")
    local tabContentFlow = LSlib.gui.layout.addFlow(layoutTable, tabFrame, tabName.."content", "vertical"  )

    -- adding tabs
    for _,tabPage in pairs(tabPages or {}) do
      LSlib.gui.layout.addButton(layoutTable, tabButtonFlow , tabName..tabPage.name, {
        caption = tabPage.caption,
      })
      if tabPage.enabled then
        LSlib.gui.layout.addFrame (layoutTable, tabContentFlow, tabName..tabPage.name, "vertical")
      end
    end

    return tabContentFlow
  end

end
