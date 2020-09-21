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

sounds = {
    ['paddleHit'] = love.audio.newSource('assets/sounds/PaddleHit.wav', 'static'),
    ['wallHit'] = love.audio.newSource('assets/sounds/WallHit.wav', 'static'),
    ['background'] = love.audio.newSource('assets/sounds/Background.mp3', 'static'),
    ['death'] = love.audio.newSource('assets/sounds/Death.wav', 'static'),
    ['powerUp'] = love.audio.newSource('assets/sounds/PowerUp.wav', 'static'),
    ['gameOver'] = love.audio.newSource('assets/sounds/GameOver.wav', 'static'),
    ['menuOpen'] = love.audio.newSource('assets/sounds/MenuOpen.wav', 'static'),
    ['menuOption'] = love.audio.newSource('assets/sounds/MenuOption.wav', 'static')
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
            sounds['menuOpen']:play()
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

    if key == 'enter' or key == 'return' or key == 'space' then
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
    sounds['background']:setLooping(true)
    sounds['background']:play()

    startMenu = Menu()
    pauseMenu = PauseMenu()
    ball = Ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 10, 10)
    aiPlayer = AiPaddle(30, 80, 8, 120)
    realPlayer = Paddle(30, 80, 8, 120, 'w', 's')
    player1 = realPlayer
    player2 = Paddle(WINDOW_WIDTH-30, WINDOW_HEIGHT-80, 8, 120, 'up', 'down')
    gameOver = 'none'

    currentState = gameState.startMenu
end

function love.update(dt)
    if currentState == gameState.winPlayer1 or currentState == gameState.winPlayer2 then
        sounds['background']:pause()
        sounds['death']:play()
        gameOver = currentState
        love.timer.sleep(0.5)
        currentState = gameState.startMenu
        sounds['gameOver']:play()
        love.timer.sleep(1.6)
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
        if not sounds['background']:isPlaying() then
            sounds['background']:play()
        end
        ball:update(dt)
    end

    if currentState == gameState.play then
        player1:update(dt)
        player2:update(dt)
    end

    collision = 'none'
    if ball:collides(player1) then
        collision = player1
    elseif ball:collides(player2) then
        collision = player2
    end

    if collision ~= 'none' then
        sounds['paddleHit']:play()
        -- ball-paddle-Dist
        bottomTopDist = (ball.y+ball.height/2) - (collision.y-collision.height/2)
        topBottomDist = (collision.y+collision.height/2) - (ball.y-ball.height/2)
        leftRightDist = (collision.x+collision.width/2) - (ball.x-ball.width/2)
        rightLeftDist = (ball.x+ball.width/2) - (collision.x-collision.width/2)

        if ball.y > collision.y-collision.height/2 and ball.y < collision.y+collision.height/2 then
            ball.dx = -ball.dx
        elseif bottomTopDist < topBottomDist then
        -- handling corner cases
            -- collision at top side of paddle
            if bottomTopDist < leftRightDist or bottomTopDist < rightLeftDist then
                ball.dy = -ball.dy
                ball.y = ball.y - (bottomTopDist + 1)
            else 
                ball.dx = - ball.dx
            end
        else
            -- collision at the bottom side of the paddle
            if topBottomDist < leftRightDist or topBottomDist < rightLeftDist then
                ball.dy = -ball.dy
                ball.y = ball.y + (topBottomDist + 1)
            else 
                ball.dx = -ball.dx
            end
        end
        if ball.dx > 0 then
            ball.x = ball.x + (leftRightDist + 1)
        else
            ball.x = ball.x - (rightLeftDist + 1)
        end
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
