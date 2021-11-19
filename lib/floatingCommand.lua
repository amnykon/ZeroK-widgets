function floatingCommand(obj)
  --[[
    obj.name
    obj.action
    obj.contents
    obj.hotkey
    obj.x
    obj.y
    obj.children
  --]]
  local screenWidth, screenHeight = Spring.GetViewGeometry()
  local size = 45

  local x
  if obj.x < 0 then
    x = obj.x * size + screenWidth
  else
    x = obj.x * size
  end

  local y
  if obj.y < 0 then
    y = obj.y * size + screenHeight
  else
    y = obj.y * size
  end

  local window = WG.Chili.Window:New{
    name = obj.name,
    parent = WG.Chili.Screen0,
    padding = {-1, 0, -1, -1},
    itemMargin = {0, 0, 0, 0},
    x = x,
    y = y,
    width  = size,
    height = size,
    dockable  = true,
    draggable = false,
    resizable = false,
    tweakDraggable = true,
    tweakResizable = true,
    minWidth = 32,
    minHeight = 32,
    color = {0,0,0,0},
    children = {
      WG.Chili.Button:New{
        caption = '',
        padding = {1,1,1,1},
        width  = size,
        height = size,
        backgroundColor = backgroundColor,
        OnClick = {
          obj.action
        },
        children = obj.contents
      }
    }
  }

  window:BringToFront()

  window:SetVisibility(true)

  for _, child in ipairs(obj.children or {}) do
    floatingCommand(child)
  end
end

