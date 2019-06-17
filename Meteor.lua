Meteor = Class{}

local METEOR_IMAGE = love.graphics.newImage('meteor.png')
local speed = 400

function Meteor:init()
    self.image = love.graphics.newImage('meteor.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = math.random(-50 , WINDOW_WIDTH)
    self.y = 0 - self.height  
end

function Meteor:update(dt)
    self.y = self.y + speed * dt
end

function Meteor:render()
    love.graphics.draw(self.image, self.x, self.y)
end
