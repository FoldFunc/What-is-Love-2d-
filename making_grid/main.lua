Grid_Line = {}

function Grid_Line:new(x, y, w, h, color, ver)
  local obj = {
    x = x or 0,
    y = y or 0,
    w = w or 0,
    h = h or 0,
    color = color or { 1, 1, 1 },
    ver = ver or 0
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Grid_Line:update(dt)
  if self.ver == 0 then
    if love.keyboard.isDown("h") then
      self.x = self.x - 1000 * dt
    elseif love.keyboard.isDown("l") then
      self.x = self.x + 1000 * dt
    end
  elseif self.ver == 1 then
    if love.keyboard.isDown("k") then
      self.y = self.y + 1000 * dt
    elseif love.keyboard.isDown("j") then
      self.y = self.y - 1000 * dt
    end
  end
end

function Grid_Line:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

local Grids_ver = {}
local Grids_hor = {}

function love.load()
  love.window.setMode(1080, 720, { resizable = false })

  -- vertical lines (|), from left to right
  for x = -100000, 100000, 25 do
    local line = Grid_Line:new(x, 0, 4, 720, { 1, 1, 1 }, 0)
    table.insert(Grids_ver, line)
  end

  -- horizontal lines (-), from top to bottom
  for y = -1000000, 100000, 25 do
    local line = Grid_Line:new(0, y, 1080, 4, { 1, 1, 1 }, 1)
    table.insert(Grids_hor, line)
  end
end

function love.update(dt)
  for _, grid in ipairs(Grids_ver) do
    grid:update(dt)
  end
  for _, grid in ipairs(Grids_hor) do
    grid:update(dt)
  end
end

function love.draw()
  for _, grid in ipairs(Grids_ver) do
    grid:draw()
  end
  for _, grid in ipairs(Grids_hor) do
    grid:draw()
  end
end
