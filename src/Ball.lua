Class = require 'class'

Ball = Class{}

function randDir(val)
    if math.random(-5, 5) <= 0 then
        return -val
    end
    return val
end

function Ball:init(x, y, width, height)
    -- save original coordinates
    self.origX = x
    self.origY = y
    -- center position of the ball
    self.x = x
    self.y = y
    -- size of the ball
    self.width = width
    self.height = height
    -- speed of the ball
    self.dx = randDir(math.random(150, 200))
    self.dy = randDir(math.random(100, 200))
end

function Ball:reset()
    self.x = self.origX
    self.y = self.origY
    self.dx = randDir(math.random(150, 200))
    self.dy = randDir(math.random(100, 200))
end

function increaseMagnitude(val, increment)
    if val > 0 then
        return val + increment
    else
        return val - increment
    end
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
        -- increase speed and return true
        self.dx = increaseMagnitude(self.dx, 10)
        self.dy = increaseMagnitude(self.dy, 10)
        return true
    else
        return false
    end
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- if out of bounds, adjust the coordinates
    self.y = math.min(math.max(self.y, self.height/2), WINDOW_HEIGHT - self.height/2)

    if self.y+self.height/2 >= WINDOW_HEIGHT or self.y-self.height/2 <= 0 then
        sounds['wallHit']:play()
        self.dy = -self.dy
    end

    if currentState ~= gameState.play and (self.x+self.width/2 > WINDOW_WIDTH or self.x-self.width/2 < 0) then
        self.dx = -self.dx
    end

    if currentState == gameState.play and self.x+self.width/2 > WINDOW_WIDTH then
        currentState = gameState.winPlayer1
    elseif currentState == gameState.play and self.x-self.width/2 < 0 then
        currentState = gameState.winPlayer2
    end
end

function Ball:render()
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)
end
