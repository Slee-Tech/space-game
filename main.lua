Class = require 'class'
require 'Laser'
require 'Rocket'
require 'Meteor'

-- all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleState'
require 'states/ScoreState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
font = love.graphics.newFont(15)
titleFont = love.graphics.newFont(50)

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(font)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        resizable = false,
        fullscreen = false
    })
    love.window.setTitle('Space Game')

    sounds = {
        ['collide'] = love.audio.newSource('sounds/collide.wav', 'static'),
        ['laser'] = love.audio.newSource('sounds/laser.wav', 'static'),
        ['play'] = love.audio.newSource('sounds/play.wav', 'static'),
        ['title'] = love.audio.newSource('sounds/title.wav', 'static')
    }    

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keyPressed = {}
end

function love.keypressed(key)
    love.keyboard.keyPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

-- allows keypress to be used outside of main
function love.keyboard.wasPressed(key)
    if love.keyboard.keyPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- all game logic moved to states
    gStateMachine:update(dt)
    love.keyboard.keyPressed = {}
end

function love.draw()
    -- all rendering moved to states
    gStateMachine:render()
end