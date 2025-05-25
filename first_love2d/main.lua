_G.love = require("love")
-- Square "class"
Square = {}

function Square:new(x, y, w, h, color, pn)
  local obj = {
    x = x or 0,
    y = y or 0,
    w = w or 0,
    h = h or 0,
    color = color or { 1, 1, 1 },
    pn = pn or 0
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Square:update(dt)
  if self.pn == 0 then
    if love.keyboard.isDown("w") then
      self.y = self.y - 400 * dt
    elseif love.keyboard.isDown("s") then
      self.y = self.y + 400 * dt
    end
  elseif self.pn == 1 then
    if love.keyboard.isDown("up") then
      self.y = self.y - 400 * dt
    elseif love.keyboard.isDown("down") then
      self.y = self.y + 400 * dt
    end
  end
  -- Clamp paddle inside the window vertically
  self.y = math.max(0, math.min(self.y, WinHeight - self.h))
end

function Square:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

-- Ball "class"
Ball = {}

function Ball:new(x, y, r, xspeed, yspeed, color)
  local obj = {
    x = x or 0,
    y = y or 0,
    r = r or 10,
    xspeed = xspeed or 0,
    yspeed = yspeed or 0,
    color = color or { 1, 1, 1 }
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Ball:update(dt, WinWidth, WinHeight)
  self.x = self.x + self.xspeed * dt
  self.y = self.y + self.yspeed * dt

  -- Wall bounce
  if self.y + self.r > WinHeight or self.y - self.r < 0 then
    self.yspeed = -self.yspeed
  end

  -- Paddle bounce
  if self:checkCollision(Square1) or self:checkCollision(Square2) then
    self.xspeed = -self.xspeed
  end

  -- Left or right screen edge (reset ball and add point)
  if self.x - self.r < 0 then
    self.x = WinWidth / 2
    self.y = WinHeight / 2
    PointsPlayer2 = PointsPlayer2 + 1
  end
  if self.x + self.r > WinWidth then
    self.x = WinWidth / 2
    self.y = WinHeight / 2
    PointsPlayer1 = PointsPlayer1 + 1
  end
end

function Ball:checkCollision(square)
  -- Closest point on rectangle to circle
  local closestX = math.max(square.x, math.min(self.x, square.x + square.w))
  local closestY = math.max(square.y, math.min(self.y, square.y + square.h))

  -- Distance from circle center to that point
  local dx = self.x - closestX
  local dy = self.y - closestY

  -- If distance is less than radius, collision!
  return (dx * dx + dy * dy) < (self.r * self.r)
end

function Ball:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle("fill", self.x, self.y, self.r)
end

-- Main LÖVE callbacks

local scoreFont

function love.load()
  WinWidth = 1080
  WinHeight = 720

  local R = 90 / 255
  local G = 90 / 255
  local B = 90 / 255

  Player1 = 0
  Player2 = 1

  PointsPlayer1 = 0
  PointsPlayer2 = 0

  Square1 = Square:new(100, 100, 10, 200, { R, G, B }, Player1)
  Square2 = Square:new(980, 100, 10, 200, { R, G, B }, Player2)
  Ball = Ball:new(500, 500, 30, 300, 300, { R, G, B })

  -- Load custom font from props directory at size 48 for score display
  scoreFont = love.graphics.newFont("props/font.ttf", 48)
end

function love.update(dt)
  Square1:update(dt)
  Square2:update(dt)
  Ball:update(dt, WinWidth, WinHeight)
end

function DrawScore(p1, p2)
  love.graphics.setFont(scoreFont)
  love.graphics.setColor(1, 1, 1) -- White color for text

  love.graphics.print(tostring(p1), 110, 20)

  local p2text = tostring(p2)
  local p2width = scoreFont:getWidth(p2text)
  love.graphics.print(p2text, WinWidth - 100 - p2width, 20)
end

function love.draw()
  Square1:draw()
  Square2:draw()
  Ball:draw()
  DrawScore(PointsPlayer1, PointsPlayer2)
end
