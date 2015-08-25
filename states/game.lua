game = {}

function game:enter()
    self.rotator = Rotator:new()
	self.rotatorList = {}
	
	for i = 1, 10 do
		table.insert(self.rotatorList, Rotator:new(20*(i-1)+5, 15))
	end
	
	self.freeze = true
end

function game:update(dt)
	if not self.freeze then
		for k, rotator in pairs(self.rotatorList) do
			rotator:update(dt)
		end
	end
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	if key == ' ' then
		self.freeze = not self.freeze
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
end

function game:draw()
    for k, rotator in pairs(self.rotatorList) do
		rotator:draw()
	end
	
	love.graphics.print(love.timer.getFPS(), 5, 5)
	love.graphics.print('Press space to toggle pause', 5, 40)
end