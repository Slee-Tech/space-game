ScoreState = Class{__includes = BaseState}

local bgImage = love.graphics.newImage('nebula.jpg')

function ScoreState:enter(params)
    self.time = params.time
    self.hits = params.hits
    love.audio.stop()
    sounds['collide']:play()
    sounds['title']:setLooping(true)
    sounds['title']:play()
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    love.graphics.setFont(font)
    love.graphics.draw(bgImage, 0, 0)
    love.graphics.printf('TIME: ' .. tostring(math.floor(self.time)), 0, (WINDOW_HEIGHT/2)-25, WINDOW_WIDTH, 'center')
    love.graphics.printf('METEORS HIT: ' .. tostring(self.hits), 0, (WINDOW_HEIGHT/2), WINDOW_WIDTH, 'center')
    love.graphics.printf('PRESS ENTER TO PLAY AGAIN', 0, (WINDOW_HEIGHT/2)+30, WINDOW_WIDTH, 'center')
end

