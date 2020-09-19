Class = require 'class'

require 'Ball'
require 'Paddle'
require 'AiPaddle'
require 'Menu'
require 'PauseMenu'

WINDOW_WIDTH = 1000
WINDOW_HEIGHT = 560

fonts = {
    ['retroS'] = love.graphics.newFont('assets/fonts/Retro_Gaming.ttf', 16),
    ['retroL'] = love.graphics.newFont('assets/fonts/Retro_Gaming.ttf', 26),
    ['retroXL'] = love.graphics.newFont('assets/fonts/Retro_Gaming.ttf', 42)
}

gameState = {
    ['startMenu'] = 'Start Menu',
    ['pauseMenu'] = 'Pause Menu',
    ['setAi'] = 'AI Start',
    ['setPlayer'] = 'Player Start',
    ['start'] = 'Start',
    ['play'] = 'Play',
    ['pause'] = 'Pause',
    ['winPlayer1'] = 'Player 1 Won',
    ['winPlayer2'] = 'Player 2 Won'
}

function love.keypressed(key)
    if key == 'escape' then
        if currentState == gameState.play then
            currentState = gameState.pauseMenu
        elseif currentState == gameState.pauseMenu then
            currentState = gameState.play
        end
    end

    if currentState == gameState.startMenu then
        if startMenu:changeSelection(key) then
            return
        end
    end

    if currentState == gameState.pauseMenu then
        if pauseMenu:changeSelection(key) then
            return
        end
    end

    if key == 'enter' or key == 'return' then
        if currentState == gameState.startMenu then
            startMenu:performSelection()
        elseif currentState == gameState.pauseMenu then
            pauseMenu:performSelection()
        end
        return
    end
end

function love.load()
    -- set love's default to "nearest-neighbour" which means there will be no filtering of pixels for a better 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Pong Remade')

    -- set random seed for random number
    math.randomseed(os.time())

    -- set window properties
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    love.graphics.setFont(fonts.retroS)

    startMenu = Menu()
    pauseMenu = PauseMenu()
    ball = Ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 10, 10)
    aiPlayer = AiPaddle(30, 80, 5, 120)
    realPlayer = Paddle(30, 80, 5, 120, 'w', 's')
    player1 = realPlayer
    player2 = Paddle(WINDOW_WIDTH-30, WINDOW_HEIGHT-80, 5, 120, 'up', 'down')
    gameOver = 'none'

    currentState = gameState.startMenu
end

function love.update(dt)
    if currentState == gameState.winPlayer1 or currentState == gameState.winPlayer2 then
        gameOver = currentState
        love.timer.sleep(0.5)
        currentState = gameState.startMenu
    end

    if currentState == gameState.setAi then
        player1 = aiPlayer
        currentState = gameState.start
    elseif currentState == gameState.setPlayer then
        player1 = realPlayer
        currentState = gameState.start
    end

    if currentState == gameState.start then
        gameOver = 'none'
        ball:reset()
        player1:reset()
        player2:reset()
        currentState = gameState.play
    end

    if currentState == gameState.startMenu or currentState == gameState.play then
        ball:update(dt)
    end

    if currentState == gameState.play then
        player1:update(dt)
        player2:update(dt)
    end

    if ball:collides(player1) or ball:collides(player2) then
        ball.dx = -ball.dx
    end
end

function love.draw()
    -- wipe screen
    love.graphics.clear(20/255, 20/255, 20/255, 1)

    ball:render()
    player1:render()
    player2:render()
    if currentState == gameState.startMenu then
        startMenu:render()
    elseif currentState == gameState.pauseMenu then
        pauseMenu:render()
    end

    if gameOver ~= 'none' then
        love.graphics.setFont(fonts.retroXL)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(gameOver, WINDOW_WIDTH/2-fonts['retroXL']:getWidth(gameOver)/2, WINDOW_HEIGHT/6)
    end
end
