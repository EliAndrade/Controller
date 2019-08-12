local Controller = {}
Controller.buttons = {
	["test"] = {
		keyboard = {},
		joystick = {}
	}
}
Controller.buttonMap = {}
Controller.axis = {}
Controller.joystick = nil

Controller.deadzone = 0.5

function Controller:new(t, joystick, deadzone)
	local o = {}
	o.buttons = t
	o.buttonMap = {}
	for i, v in pairs(t) do
		table.insert(o.buttonMap, i)
		v.down = false
	end
	o.joystick = joystick
	o.deadzone = deadzone or 0.5
	o.__index = self
	setmetatable(o, o)
	return o
end

function Controller:keypressed(key)
	local pressed = {}
	
	for i, v in ipairs(self.buttonMap) do
		if self.buttons[v].keyboard then
			for j, k in ipairs(self.buttons[v].keyboard) do
				if key == k then
					self.buttons[v].down = true
					table.insert(pressed, v)
				end
			end
		end
	end
	
	return pressed
end

function Controller:keyreleased(key)
	local released = {}

	for i, v in ipairs(self.buttonMap) do
		if self.buttons[v].keyboard then
			for j, k in ipairs(self.buttons[v].keyboard) do
				if key == k then
					self.buttons[v].down = false
					table.insert(released, v)
				end
			end
		end
	end
	
	return released
end

function Controller:joystickpressed(joystick, button)
	local pressed = {}

	if self.joystick == joystick then
		for i, v in ipairs(self.buttonMap) do
			if self.buttons[v].joystick then
				for j, k in ipairs(self.buttons[v].joystick) do
					if button == k then
						self.buttons[v].down = true
						table.insert(pressed, v)
					end
				end
			end
		end
	end
	
	return pressed
end

function Controller:joystickreleased(joystick, button)
	local released = {}

	if self.joystick == joystick then
		for i, v in ipairs(self.buttonMap) do
			if self.buttons[v].joystick then
				for j, k in ipairs(self.buttons[v].joystick) do
					if button == k then
						self.buttons[v].down = false
						table.insert(released, v)
					end
				end
			end
		end
	end
	
	return released
end

function Controller:joystickaxis(joystick, axis, value)
	local pressed = {}
	local released = {}

	if self.joystick == joystick then
		for i, v in ipairs(self.buttonMap) do
			if self.buttons[v].axis then
				for j, k in ipairs(self.buttons[v].axis) do
					local dir = value >= 0 and 1 or -1
					value = math.abs(value)
					if axis*dir == k then	
						local b = (value  > self.deadzone and not self.buttons[v].down) or 
								  (value <= self.deadzone and     self.buttons[v].down)
						
						if b then
							self.buttons[v].down = value  > self.deadzone				
							if value  > self.deadzone then
								table.insert(pressed, v)
							else
								table.insert(released, v)
							end
						end
					end
				end
			end
		end
	end
	
	return pressed, released
end

function Controller:isDown(button)
  if self.buttons[button] then
		return self.buttons[button].down
	else
		return false
	end
end

return Controller
