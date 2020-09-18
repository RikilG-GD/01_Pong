Class = require 'class'

Ball = Class{}

function Ball:init(x, y, width, height)
    --center position of the ball
    self.x = x
    self.y = y
    -- size of the ball
    self.width = width
    self.height = height
    -- speed of the ball
    self.dx = 200
    self.dy = 200
end

function Ball:collides(obj)
    -- some variable bounds for better understanding
    ballLeft = self.x - self.width/2
    ballRight = self.x + self.width/2
    ballTop = self.y - self.height/2
    ballBottom = self.y + self.height/2
    objLeft = obj.x - obj.width/2
    objRight = obj.x + obj.width/2
    objTop = obj.y - obj.height/2
    objBottom = obj.y + obj.height/2

    if ballLeft <= objRight and ballRight >= objLeft and ballTop <= objBottom and ballBottom >= objTop then
        return true
    else
        return false
    end
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.y+self.height/2 > WINDOW_HEIGHT or self.y-self.height/2 < 0 then
        self.dy = -self.dy
    end

    if self.x+self.width/2 > WINDOW_WIDTH or self.x-self.width/2 < 0 then
        self.dx = -self.dx
    end
end

function Ball:render()
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)
end
