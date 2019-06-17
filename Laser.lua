Laser = Class{}

local METEOR_IMAGE = love.graphics.newImage('laser_1.png')
local speed = 800

function Laser:init(rocket)
    self.x = rocket.x + 22
    self.y = rocket.y
    self.image = love.graphics.newImage('laser_1.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Laser:collides(meteor)
    if self.x + self.width >= meteor.x and self.x <= meteor.x + meteor.width then
        if self.y + self.height >= meteor.y + 50 and self.y <= meteor.y + meteor.height then
            return true
        end
    end

    return false
end

function Laser:update(dt)
    self.y = self.y - (speed * dt)
end

function Laser:render()
    love.graphics.draw(self.image, self.x, self.y)
end