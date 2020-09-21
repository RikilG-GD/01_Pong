Powerup = Class{}

POWERUP_IMAGE = love.graphics.newImage('assets/sprites/star.png')
POWERUP_MAXTIME = 15 -- seconds

totalPowerups = 3
powerups = {
    [0] = { -- no powerup
        ['init'] = function(obj) end,
        ['update'] = function(obj, dt) end,
        ['finish'] = function(obj) end
    },
    [1] = { -- increase player paddle height
        ['init'] = function(obj) obj.height = obj.height + 50 end,
        ['update'] = function(obj, dt)
                obj.powerupTime = obj.powerupTime + dt
                if obj.powerupTime > POWERUP_MAXTIME then
                    obj.powerupTime = 0
                    obj.powerup.finish(obj)
                    obj.powerup = powerups[0]
                end
            end,
        ['finish'] = function(obj, noPlay)
                obj.height = obj.origHeight
                if not noplay then sounds['powerDown']:play() end
            end
    },
    [2] = { -- decrease player paddle height
        ['init'] = function(obj) obj.height = obj.height - 40 end,
        ['update'] = function(obj, dt)
                obj.powerupTime = obj.powerupTime + dt
                if obj.powerupTime > POWERUP_MAXTIME then
                    obj.powerupTime = 0
                    obj.powerup.finish(obj)
                    obj.powerup = powerups[0]
                end
            end,
        ['finish'] = function(obj, noplay)
                obj.height = obj.origHeight
                if not noplay then sounds['powerDown']:play() end
            end
    },
    [3] = { -- increase paddle speed
        ['init'] = function(obj) obj.dy = obj.dy + 350 end,
        ['update'] = function(obj, dt)
                obj.powerupTime = obj.powerupTime + dt
                if obj.powerupTime > POWERUP_MAXTIME then
                    obj.powerupTime = 0
                    obj.powerup.finish(obj)
                    obj.powerup = powerups[0]
                end
            end,
        ['finish'] = function(obj, noplay)
                obj.dy = obj.origSpeed
                if not noplay then sounds['powerDown']:play() end
            end
    }
}

function randDir(val)
    if math.random(-5, 5) <= 0 then
        return -val
    end
    return val
end

function Powerup:init()
    self.active = false
    self.x = 0
    self.y = 0
    self.dx = randDir(math.random(20, 80))
    self.dy = randDir(math.random(20, 80))
    self.width = POWERUP_IMAGE:getWidth()
    self.height = POWERUP_IMAGE:getHeight()
end

function Powerup:spawn()
    self.active = true
    self.x = WINDOW_WIDTH/2
    self.y = WINDOW_HEIGHT/2
    self.dx = randDir(math.random(20, 80))
    self.dy = randDir(math.random(20, 80))
end

function Powerup:apply(player)
    if player.powerup ~= 'none' then
        player.powerup.finish(player, true)
        player.powerupTime = 0
    end
    num = math.random(1, totalPowerups)
    player.powerup = powerups[num]
    player.powerup.init(player)
    sounds['powerUp']:play()
end

function Powerup:update(dt)
    if self.active == false then
        return
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- if out of bounds, adjust the coordinates
    self.y = math.min(math.max(self.y, self.height/2), WINDOW_HEIGHT - self.height/2)

    if self.y+self.height/2 >= WINDOW_HEIGHT or self.y-self.height/2 <= 0 then
        self.dy = -self.dy
    end

    if self.x > WINDOW_WIDTH or self.x < 0 then
        self.active = false
    end
end

function Powerup:collides(obj)
    if self.active == false then
        return false
    end
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
        self.active = false
        return true
    else
        return false
    end
end

function Powerup:render()
    if self.active then
        love.graphics.draw(POWERUP_IMAGE, self.x-self.width/2, self.y-self.height/2)
    end
end
