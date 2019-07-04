Rocket = Class{}

function Rocket:init()
    self.image = love.graphics.newImage('rocket_1.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = WINDOW_WIDTH / 2 - (self.width / 2)
    self.y = WINDOW_HEIGHT - (self.height + 30)
    self.shoot = false
end

function Rocket:collides(meteor)
    if self.x + self.width >= meteor.x + 20 and self.x <= meteor.x + meteor.width then
        if self.y + self.height >= meteor.y + 20 and self.y <= meteor.y + meteor.height then
            return true
        end
    end

    return false
end

function Rocket:update(dt)

    if love.keyboard.isDown('left') then
        self.x = math.max(0, self.x - (500 * dt))
    end

    if love.keyboard.isDown('right') then
        self.x = math.min(WINDOW_WIDTH - self.width, self.x + (500 * dt))
    end

    -- check for laser shot
    if love.keyboard.wasPressed('space') then
        self.shoot = true
        sounds['laser']:play()
    end

end

function Rocket:render()
    love.graphics.draw(self.image, self.x, self.y)
end