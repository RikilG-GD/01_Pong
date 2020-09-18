Class = require 'class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

fonts = {
    ['retro'] = love.graphics.newFont('assets/fonts/Retro_Gaming.ttf', 16),
}

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.load()
    -- set love's default to "nearest-neighbour" which means there will be 
    -- no filtering of pixels for a better 2D look
    -- love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Pong Remastered')

    -- set random seed for random number
    math.randomseed(os.time())

    -- set window properties
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    love.graphics.setFont(fonts.retro)

    ball = Ball(WINDOW_WIDTH/2 - 6, WINDOW_HEIGHT/2 - 6, 12, 12)
    player1 = Paddle(30, 70, 15, 120, 'w', 's')
    player2 = Paddle(WINDOW_WIDTH-30, WINDOW_HEIGHT-70, 15, 120, 'up', 'down')
end

function love.update(dt)
    ball:update(dt)
    player1:update(dt)
    player2:update(dt)

    if ball:collides(player1) or ball:collides(player2) then
        ball.dx = -ball.dx
    end
end

function love.draw()
    love.graphics.clear(20/255, 20/255, 20/255, 1)
    ball:render()
    player1:render()
    player2:render()
end
