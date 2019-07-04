PlayState = Class{__includes = BaseState}

-- include main game logic from update and render functions
local background = love.graphics.newImage('space.jpg')
local backgroundScrollSpeed = 200
local backgroundLoopPoint = 721

function PlayState:init()
    self.rocket = Rocket()
    self.scrolling = true
    self.timerScore = 0
    self.reduceTimer = 2
    self.meteors = {}
    self.shots = {}
    self.timer = 0
    self.meteorsHit = 0
    self.backgroundScroll = 0
end

function PlayState:enter()
    love.audio.stop()
    sounds['play']:setLooping(true)
    sounds['play']:play()
   
end

function PlayState:update(dt)
    if self.scrolling then 

        self.backgroundScroll = (self.backgroundScroll + backgroundScrollSpeed * dt) % backgroundLoopPoint
        
        self.timerScore = self.timerScore + dt
        
        -- add meteors
        self.timer = self.timer + dt
        if self.timer > self.reduceTimer then
            table.insert(self.meteors, Meteor())
            self.timer = 0
            self.reduceTimer = self.reduceTimer - .05
            if self.reduceTimer < .5 then
                self.reduceTimer = .5
            end
        end
        
        -- update rocket
        self.rocket:update(dt)
    
        -- checks for laser shot than adds it to shots table
        if self.rocket.shoot then
            table.insert(self.shots, Laser(self.rocket))
            self.rocket.shoot = false
        end
    
        -- update meteors
        for k, meteor in pairs(self.meteors) do
            meteor:update(dt)
            if meteor.y > WINDOW_HEIGHT then
                table.remove(self.meteors, k)
            end
    
            -- will switch to score state here after rocket is hit
            if self.rocket:collides(meteor) then
                --self.scrolling = false
                gStateMachine:change('score', {
                    time = self.timerScore,
                    hits = self.meteorsHit
                })
            end
    
        end
    
        -- add shots then update them
        for s, shot in pairs(self.shots) do
            shot:update(dt)
    
            if shot.y < 0 then
                table.remove(self.shots, s)
            end
            -- check if shot collides with a meteor
            for i, meteor in pairs(self.meteors) do
                if shot:collides(meteor) then
                    sounds['collide']:play()
                    table.remove(self.meteors, i)
                    table.remove(self.shots, s)
                    self.meteorsHit = self.meteorsHit + 1
                end
            end
        end
    
    end
end

function PlayState:render()
    love.graphics.draw(background, 0, -self.backgroundScroll)
    
    -- displays current time and score
    love.graphics.print('Time: ' .. math.floor(self.timerScore), 20, 15)
    love.graphics.print('Score: ' .. self.meteorsHit, 110, 15)

    -- render rocket
    self.rocket:render()

    -- render meteors
    for k, meteor in pairs(self.meteors) do
        meteor:render()
    end

    -- render shots
    for s, shot in pairs(self.shots) do
        shot:render()
    end
end