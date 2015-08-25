Rotator = class('Rotator')

function Rotator:initialize(radius, width, color)
	self.radius = radius or 200
	self.width = width or 30
	
	self.total = self.radius*8
	self.percent = 0
	self.distance = 0
	self.speedMax = self.radius^2/16
	self.speedMin = self.speedMax/2
	self.speed = 0
	
	self.accel = self.speedMax/20
	
	self.centerX, self.centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	
	self.color = color
end

function Rotator:update(dt)
	self.distance = self.distance + self.speed*dt
	local newPercent = self.distance/self.total
	
	if newPercent > 1 then
		newPercent = newPercent % 1
	elseif newPercent < 1 then
		newPercent = newPercent % 1
	end
	
	self.percent = newPercent
	
	--if self.speed < self.speedMax then
		--self.speed = self.speed + self.accel*dt
	--end
	
	if self.speed > self.speedMax then
		--self.speed = self.speedMax
	end
	
	self.speed = math.sin(game.t/100) * self.speedMax * game.t / 100 * 1000
	
	local r,g,b,a = HSL((game.t*5) % 255, (self.radius*5 + game.t) % 255, 255 - 255*self.percent, 255) -- tile colors generated over HSL color system
	self.color = {r,g,b,a}
end

function Rotator:draw()
	local x, y, r, p, w = self.centerX, self.centerY, self.radius, self.percent, self.width
	
	love.graphics.setColor(255, 255, 255)
	--love.graphics.line(x-r, y-r, x+r, y-r, x+r, y+r, x-r, y+r, x-r, y-r)
	--love.graphics.line(x-r-w, y-r-w, x+r+w, y-r-w, x+r+w, y+r+w, x-r-w, y+r+w, x-r-w, y-r-w)
	
	local frontX1, frontY1, frontX2, frontY2 = self:getPoint(x, y, r, p, w)
	local p2 = p + .5
	if p2 > 1 then p2 = p2 - 1 end
	local backX1, backY1, backX2, backY2 = self:getPoint(x, y, r, p2, w)
	
	local poly = {}
	if p >= 0 and p < .25 then -- include 2 right points
		poly = {frontX1, frontY1, x+r, y+r, x+r, y-r, backX1, backY1, backX2, backY2, x+r+w, y-r-w, x+r+w, y+r+w, frontX2, frontY2}
	elseif p >= .25 and p <.5 then -- include bottom 2 points
		poly = {frontX1, frontY1, x-r, y+r, x+r, y+r, backX1, backY1, backX2, backY2, x+r+w, y+r+w, x-r-w, y+r+w, frontX2, frontY2}
	elseif p >= .5 and p < .75 then -- include left 2 points
		poly = {frontX1, frontY1, x-r, y-r, x-r, y+r, backX1, backY1, backX2, backY2, x-r-w, y+r+w, x-r-w, y-r-w, frontX2, frontY2}
	elseif p >= .75 and p < 1 then -- include top 2 points
		poly = {frontX1, frontY1, x+r, y-r, x-r, y-r, backX1, backY1, backX2, backY2, x-r-w, y-r-w, x+r+w, y-r-w, frontX2, frontY2}
	end
	
	if #poly > 0 then
		love.graphics.setColor(self.color)
		
		local triangles = love.math.triangulate(poly)
			
		for k, tri in pairs(triangles) do
			love.graphics.polygon('fill', tri)
		end
	end
end


function Rotator:getPoint(x, y, r, p, w)
	local dx = 0
	local dy = 0
	local dx2 = 0
	local dy2 = 0
	
	if p >= 0 and p < .25 then -- bottom
		dx = r - (r*p*8)
		dy = r
		dx2 = dx*(r+w)/r
		dy2 = dy+w
	elseif p >= .25 and p < .5 then -- left
		dx = -r
		dy = r - (r*(p-.25)*8)
		dx2 = dx-w
		dy2 = dy*(r+w)/r
	elseif p >= .5 and p < .75 then -- top
		dx = -r + (r*(p-.5)*8)
		dy = -r
		dx2 = dx*(r+w)/r
		dy2 = dy-w
	elseif p >= .75 and p < 1 then -- right
		dx = r
		dy = -r + (r*(p-.75)*8)
		dx2 = dx+w
		dy2 = dy*(r+w)/r
	end
	
	dx, dy, dx2, dy2 = dx+x, dy+y, dx2+x, dy2+y
	return dx, dy, dx2, dy2
end