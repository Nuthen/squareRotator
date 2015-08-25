Slider = class('Slider')

function Slider:initialize(x, y, width, name, doFunc, min, max, floor, startVal)
	self.x = x
	self.y = y
	self.width = width
	self.name = name
	self.doFunc = doFunc
	self.min = min
	self.max = max
	self.floor = floor
	
	self.selectorWidth = 5
	self.height = 20
	
	self.lineWidth = 2

	local startPercent = self:getPercent(startVal)
	self.sliderPos = startPercent or .5
	self.value = self:getValue()
	
	self.moving = false
	
	self.font = font[32]
end

function Slider:update()
	-- click check happens at a higher level
	local mX, mY = love.mouse:getPosition()

	local x, y = self.x, self.y
	local w, h = self.width, self.height
	
	if y - h/2 <= mY and y + h/2 >= mY or self.moving then
		if x - w/2 <= mX and x + w/2 >= mX or self.moving then
			local percent = (mX-x+w/2)/w
			if mX < x-w/2 then percent = 0 end
			if mX > x+w/2 then percent = 1 end
			
			self.sliderPos = percent
			self.value = self:getValue()
			self.doFunc(self.value)
			return true
		end
	end
end

function Slider:mousepressed(mX, mY)
	local x, y = self.x, self.y
	local w, h = self.width, self.height
	
	if y - h/2 <= mY and y + h/2 >= mY then
		if x - w/2 <= mX and x + w/2 >= mX then
			local percent = (mX-x+w/2)/w
			
			self.sliderPos = percent
			self.moving = true
			self.value = self:getValue()
			self.doFunc(self.value)
			return true
		else
			self.moving = false
		end
	else
		self.moving = false
	end
end

function Slider:draw()
	love.graphics.setFont(self.font)

	local x, y = self.x, self.y
	local w, h = self.width, self.height
		
	love.graphics.setLineWidth(self.lineWidth)
	love.graphics.line(x-w/2, y, x+w/2, y)
	
	local lineH = h/2
	love.graphics.line(x-w/2, y-lineH/2, x-w/2, y+lineH/2)
	love.graphics.line(x+w/2, y-lineH/2, x+w/2, y+lineH/2)
	love.graphics.line(x, y-lineH/2, x, y+lineH/2)
	
	love.graphics.rectangle('fill', x-w/2+w*self.sliderPos-self.selectorWidth/2, y-self.height/2, self.selectorWidth, self.height)
	
	local txt = self.name..': '..self.value
	local txtW, txtH = self.font:getWidth(txt), self.font:getHeight(txt)
	love.graphics.print(txt, x-txtW/2, y-lineH/2-txtH)
end


function Slider:getValue()
	local val = (self.max - self.min) * self.sliderPos + self.min
	if self.floor then val = math.floor(val) end
	return val
end

function Slider:getPercent(val)
	local percent = (val - self.min) / (self.max - self.min)
	return percent
end