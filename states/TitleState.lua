TitleState = Class{__includes = BaseState}

-- should show title screen, pressing eneter should bring to playstate
local titleImage = love.graphics.newImage('spiral-galaxy.jpg')

function TitleState:enter()
    sounds['title']:setLooping(true)
    sounds['title']:play()
end

function TitleState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function TitleState:render()
    love.graphics.setFont(titleFont)
    love.graphics.draw(titleImage, 0, 0)
    love.graphics.printf('SPACE GAME', 0, (WINDOW_HEIGHT/2)-25, WINDOW_WIDTH, 'center')
    love.graphics.setFont(font)
    love.graphics.printf('PRESS ENTER TO PLAY', 0, (WINDOW_HEIGHT/2)+40, WINDOW_WIDTH, 'center')
end