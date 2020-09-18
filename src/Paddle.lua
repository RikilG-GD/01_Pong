Class = require 'class'

Paddle = Class{}

function Paddle:init(x, y, width, height, upKey, downKey)
    --center position of the paddle
    self.x = x
    self.y = y
    -- size of the paddle
    self.width = width
    self.height = height
    -- speed of the paddle
    self.dx = 250
    self.dy = 250
    -- paddle control keys
    self.upKey = upKey
    self.downKey = downKey
end

function Paddle:update(dt)
    --[[
    if love.keyboard.isDown('right') then
        self.x = math.min(self.x + self.dx * dt, WINDOW_WIDTH-self.width/2)
    end
    if love.keyboard.isDown('left') then
        self.x = math.max(self.x - self.dx * dt, self.width/2)
    end
    ]]
    if love.keyboard.isDown(self.downKey) then
        self.y = math.min(self.y + self.dy * dt, WINDOW_HEIGHT-self.height/2)
    end
    if love.keyboard.isDown(self.upKey) then
        self.y = math.max(self.y - self.dy * dt, self.height/2)
    end
end

function Paddle:render()
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)
end
