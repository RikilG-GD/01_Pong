Class = require 'class'

AiPaddle = Class{}

function AiPaddle:init(x, y, width, height)
    -- save original coordinates
    self.origX = x
    self.origY = y
    self.origWidth = width
    self.origHeight = height
    self.origSpeed = 300
    --center position of the paddle
    self.x = x
    self.y = y
    -- size of the paddle
    self.width = width
    self.height = height
    -- speed of the paddle
    self.dx = self.origSpeed -- not required actually
    self.dy = self.origSpeed
    -- powerup
    self.powerup = powerups[0]
    self.powerupTime = 0
end

function AiPaddle:reset()
    self.x = self.origX
    self.y = self.origY
    self.width = self.origWidth
    self.height = self.origHeight
    self.dx = self.origSpeed -- not required actually
    self.dy = self.origSpeed
    self.powerup = powerups[0]
    self.powerupTime = 0
end

function AiPaddle:update(dt)
    direction = 'none'
    if (ball.dx < 0 and ball.y > self.y) or ((not powerup.active or powerup.dx > 0) and ball.dx > 0 and self.y < WINDOW_HEIGHT/2-10) or (ball.dx > 0 and powerup.active and powerup.dx < 0 and powerup.y > self.y) then
        direction = 'down'
    elseif (ball.dx < 0 and ball.y < self.y) or ((not powerup.active or powerup.dx > 0) and ball.dx > 0 and self.y > WINDOW_HEIGHT/2+10) or (ball.dx > 0 and powerup.active and powerup.dx < 0 and powerup.y < self.y) then
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
