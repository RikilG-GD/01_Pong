Class = require 'class'

AiPaddle = Class{}

function AiPaddle:init(x, y, width, height)
    -- save original coordinates
    self.origX = x
    self.origY = y
    --center position of the paddle
    self.x = x
    self.y = y
    -- size of the paddle
    self.width = width
    self.height = height
    -- speed of the paddle
    self.dx = 300 -- not required actually
    self.dy = 300
end

function AiPaddle:reset()
    self.x = self.origX
    self.y = self.origY
end

function AiPaddle:update(dt)
    direction = 'none'
    if (ball.dx < 0 and ball.y > self.y) or (ball.dx > 0 and self.y < WINDOW_HEIGHT/2) then
        direction = 'down'
    elseif (ball.dx < 0 and ball.y < self.y) or (ball.dx > 0 and self.y > WINDOW_HEIGHT/2) then
        direction = 'up'
    end

    if direction == 'down' then
        self.y = math.min(self.y + self.dy * dt, WINDOW_HEIGHT-self.height/2)
    elseif direction == 'up' then
        self.y = math.max(self.y - self.dy * dt, self.height/2)
    end
end

function AiPaddle:render()
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)
end
