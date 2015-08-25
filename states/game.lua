game = {}

function game:enter()
	self.width = 10
	self.spacing = 5
	self.count = 10
	
	self:restart()
	self.t = 0
	
	
	-- UI
	self.sliderList = {}
	
	local w = 200
	local x, y = 20 + w/2, love.graphics.getHeight() - 20
	-- x, y, w (of slider), name, do function, minimum, maximum, floor, startPercent
	
	-- width
	table.insert(self.sliderList, Slider:new(x, y, w, 'width', function(var) game:setWidth(var) end, 1, 100, true, self.width))
	
	y = y - 64
	-- spacing
	table.insert(self.sliderList, Slider:new(x, y, w, 'spacing', function(var) game:setSpacing(var) end, 0, 20, true, self.spacing))
	
	y = y - 64
	-- count
	table.insert(self.sliderList, Slider:new(x, y, w, 'count', function(var) game:setCount(var) end, 1, 200, true, self.count))
	
	
	self.freeze = false
	self.showHUD = true
	self.oldScreenWidth, self.oldScreenHeight = love.graphics.getWidth(), love.graphics.getHeight()
	
	self.font = font[40]
end

function game:restart()
	self.rotator = Rotator:new()
	self.rotatorList = {}
	
	for i = 1, self.count do
		--local r,g,b,a = HSL(80/self.count*(i-1) + 100, 60, 200, 255) -- tile colors generated over HSL color system
	
		table.insert(self.rotatorList, Rotator:new((self.width+self.spacing)*(i-1)+5, self.width))
	end
end

function game:setVar()
	for i, rotator in ipairs(self.rotatorList) do
		rotator:setVar((self.width+self.spacing)*(i-1)+5, self.width)
	end
end

function game:update(dt)
	if not self.freeze then
		for k, rotator in pairs(self.rotatorList) do
			rotator:update(dt)
		end
	end
	
	self.t = self.t + dt
	
	if love.mouse.isDown('l') then
		for k, slider in pairs(self.sliderList) do
			slider:update()
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
	
	if key == 'f1' then
		self.showHUD = not self.showHUD
	end
	
	if key == 'f2' then
		self:toggleFullscreen()
	end
	
	if key == 'f3' then
		self:toggleVSYNC()
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	for k, slider in pairs(self.sliderList) do
		slider:mousepressed(x, y)
	end
end

function game:draw()
    for k, rotator in pairs(self.rotatorList) do
		rotator:draw()
	end
	
	if self.showHUD then
		love.graphics.setColor(255, 255, 255)
	
		love.graphics.setFont(self.font)
	
		for k, slider in pairs(self.sliderList) do
			slider:draw()
		end
		
		love.graphics.print(love.timer.getFPS()..' FPS', 5, 5)
		love.graphics.print('Press space to toggle pause', 5, 40)
		love.graphics.print('F1 to toggle HUD', 5, 75)
		love.graphics.print('F2 to go fullscreen', 5, 110)
		love.graphics.print('F3 to toggle vsync', 5, 145)
	end
end


function game:setWidth(width)
	self.width = width
	self:setVar()
end

function game:setSpacing(spacing)
	self.spacing = spacing
	self:setVar()
end

function game:setCount(count)
	self.count = count
	self:restart()
end

function game:toggleFullscreen()
	if love.window.getFullscreen() then
		local width, height, flags = love.window.getMode()
		local width, height = self.oldScreenWidth, self.oldScreenHeight
		love.window.setMode(width, height, flags)
		self:resize(width, height)
	else
		self.oldScreenWidth, self.oldScreenHeight = love.graphics.getWidth(), love.graphics.getHeight()
	
		local width, height = love.window.getDesktopDimensions()
		love.window.setMode(width, height, {fullscreen = true, fsaa = 4})
		
		self:resize(width, height)
	end
end

function game:resize(w, h)
	local sliderWidth = 200
	local x, y = 20 + sliderWidth/2, h - 20
	
	for i, slider in ipairs(self.sliderList) do
		slider.x = x
		slider.y = y
		
		y = y - 64
	end
	
	for k, rotator in pairs(self.rotatorList) do
		rotator.centerX, rotator.centerY = w/2, h/2
	end
end

function game:toggleVSYNC()
	local width, height, flags = love.window.getMode()
	
	flags.vsync = not flags.vsync
	love.window.setMode(width, height, flags)
end