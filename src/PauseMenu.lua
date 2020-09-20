Class = require 'class'

PauseMenu = Class{}

function PauseMenu:init()
    -- one indexed arrays in Lua
    self.options = { 'Resume', 'Restart', 'Main Menu', 'Exit' }
    self.optionsSize = 4
    self.selection = 0
end

function PauseMenu:changeSelection(key)
    if key == 'down' then
        self.selection = (self.selection+1)%self.optionsSize
        return true
    elseif key == 'up' then
        self.selection = (self.selection-1)%self.optionsSize
        return true
    end

    return false
end

function PauseMenu:performSelection()
    if self.selection == 0 then -- play/resume
        currentState = gameState.play
    elseif self.selection == 1 then -- restart
        currentState = gameState.start
    elseif self.selection == 2 then -- main menu
        player1:reset()
        player2:reset()
        currentState = gameState.startMenu
    elseif self.selection == 3 then -- exit
        love.event.quit()
    end
end

function PauseMenu:render()
    love.graphics.setFont(fonts['retroL'])
    love.graphics.setColor(220/255, 220/255, 220/255, 0.7)
    frameWidth = WINDOW_WIDTH
    frameHeight = WINDOW_HEIGHT/3
    frameX = WINDOW_WIDTH/2-frameWidth/2
    frameY = WINDOW_HEIGHT/2-frameHeight/2
    love.graphics.rectangle('fill', frameX, frameY, frameWidth, frameHeight)

    love.graphics.setColor(0, 0, 0, 0.5)
    -- love.graphics.polygon('fill', , 200, 100, 400, 300, 400)
    -- love.graphics.print(self.options[self.selection+1], frameX+frameWidth/2, frameY+frameHeight/2)
    love.graphics.print(self.options[(self.selection-1)%self.optionsSize+1], frameWidth/3+frameX+20, frameY+2*frameHeight/6-15)
    love.graphics.print(self.options[(self.selection+1)%self.optionsSize+1], frameWidth/3+frameX+20, frameY+4*frameHeight/6-15)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(self.options[self.selection+1], frameWidth/3+frameX+20, frameY+3*frameHeight/6-15)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts.retroS)
    love.graphics.printf('<Up> and <Down> arrow-keys to control the right paddle.\n<W> and <S> keys to control the left paddle (multiplayer).\n<Esc> to pause game. <Enter> or <Space> to select option.', 115, 440, 800, 'center')
end
