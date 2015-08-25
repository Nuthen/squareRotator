game = {}

function game:enter()
    self.rotator = Rotator:new()
	self.rotatorList = {}
	
	local width = 12
	local spacing = 6
	local count = 20
	
	for i = 1, count do
		local r,g,b,a = HSL(80/count*(i-1) + 100, 60, 200, 255) -- tile colors generated over HSL color system
	
		table.insert(self.rotatorList, Rotator:new((width+spacing)*(i-1)+5, width, {r,g,b,a}))
	end
	
	self.freeze = true
	
	self.t = 0
end

function game:update(dt)
	if not self.freeze then
		for k, rotator in pairs(self.rotatorList) do
			rotator:update(dt)
		end
	end
	
	self.t = self.t + dt
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
	
	--love.graphics.print(love.timer.getFPS(), 5, 5)
	--love.graphics.print('Press space to toggle pause', 5, 40)
end