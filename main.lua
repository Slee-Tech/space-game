Class = require 'class'
require 'Laser'
require 'Rocket'
require 'Meteor'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

local background = love.graphics.newImage('space.jpg')
local font = love.graphics.newFont(15)
local rocket = Rocket()
local scrolling = true
local timerScore = 0

local meteors = {}
local shots = {}
local timer = 0
local reduceTimer = 2
local meteorsHit = 0
local backgroundScroll = 0
local backgroundScrollSpeed = 200
local backgroundLoopPoint = 721

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
    if scrolling then 

    backgroundScroll = (backgroundScroll + backgroundScrollSpeed * dt) % backgroundLoopPoint
    
    timerScore = timerScore + dt
    
    -- add meteors
    timer = timer + dt
    if timer > reduceTimer then
        table.insert(meteors, Meteor())
        timer = 0
        reduceTimer = reduceTimer - .05
        if reduceTimer < .5 then
            reduceTimer = .5
        end
    end
    
    -- update rocket
    rocket:update(dt)

    -- checks for laser shot than addes it to shots table
    if rocket.shoot then
        table.insert(shots, Laser(rocket))
        rocket.shoot = false
    end

    -- update meteors
    for k, meteor in pairs(meteors) do
        meteor:update(dt)
        if meteor.y > WINDOW_HEIGHT then
            table.remove(meteors, k)
        end

        -- will switch to score state here after rocket is hit
        if rocket:collides(meteor) then
            scrolling = false
        end

    end

    -- add shots then update them
    for s, shot in pairs(shots) do
        shot:update(dt)

        if shot.y < 0 then
            table.remove(shots, s)
        end
        -- check if shot collides with a meteor
        for i, meteor in pairs(meteors) do
            if shot:collides(meteor) then
                table.remove(meteors, i)
                table.remove(shots, s)
                meteorsHit = meteorsHit + 1
            end
        end
    end

end
    love.keyboard.keyPressed = {}
end

function love.draw()
    -- scrolls background image
    love.graphics.draw(background, 0, -backgroundScroll)
    
    -- displays current time and score
    love.graphics.print('Time: ' .. math.floor(timerScore), 20, 15)
    love.graphics.print('Score: ' .. meteorsHit, 110, 15)

    -- render rocket
    rocket:render()

    -- render meteors
    for k, meteor in pairs(meteors) do
        meteor:render()
    end

    -- render shots
    for s, shot in pairs(shots) do
        shot:render()
    end
   
end