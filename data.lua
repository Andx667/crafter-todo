-- Crafter Todo - Data Management and Saved Variables

CRAFTER_TODO = {
	db = {},
	nextId = 1,
}

-- Initialize saved variables
function CRAFTER_TODO:InitializeData()
	if not CRAFTER_TODO_DB then
		CRAFTER_TODO_DB = {
			todos = {},
			nextId = 1,
			settings = {
				windowX = 100,
				windowY = 100,
				windowWidth = 400,
				windowHeight = 500,
				showOnLogin = true,
				showMinimapButton = true,
				categories = {
					"General",
					"Alchemy",
					"Blacksmithing",
					"Cooking",
					"Enchanting",
					"Engineering",
					"First Aid",
					"Jewelcrafting",
					"Leatherworking",
					"Tailoring",
					"Other",
				},
				minimapButtonPosition = {
					point = "TOPLEFT",
					relativePoint = "TOPLEFT",
					x = -5,
					y = 5,
				}
			}
		}
	end
	self.db = CRAFTER_TODO_DB
	self.nextId = self.db.nextId

	self.db.settings = self.db.settings or {}
	self.db.settings.windowX = self.db.settings.windowX or 100
	self.db.settings.windowY = self.db.settings.windowY or 100
	self.db.settings.windowWidth = self.db.settings.windowWidth or 400
	self.db.settings.windowHeight = self.db.settings.windowHeight or 500
	self.db.settings.showOnLogin = self.db.settings.showOnLogin ~= false
	self.db.settings.showMinimapButton = self.db.settings.showMinimapButton ~= false
	self.db.settings.minimapButtonPosition = self.db.settings.minimapButtonPosition or {
		point = "TOPLEFT",
		relativePoint = "TOPLEFT",
		x = -5,
		y = 5,
	}
	self.db.settings.categories = self.db.settings.categories or {
		"General",
		"Alchemy",
		"Blacksmithing",
		"Cooking",
		"Enchanting",
		"Engineering",
		"First Aid",
		"Jewelcrafting",
		"Leatherworking",
		"Tailoring",
		"Other",
	}

	local defaultCategory = self.db.settings.categories[1] or "General"
	for _, todo in ipairs(self.db.todos or {}) do
		if not todo.category then
			todo.category = defaultCategory
		end
	end
end

-- Add a new todo
function CRAFTER_TODO:AddTodo(title, todoType, category)
	local categories = self.db.settings.categories or {"General"}
	local defaultCategory = categories[1] or "General"
	local todo = {
		id = self.nextId,
		title = title or "New Todo",
		type = todoType or "plain", -- "plain" or "materials"
		materials = {}, -- Table of materials {name, quantity, itemId}
		completed = false,
		category = category or defaultCategory,
		createdAt = time(),
		updatedAt = time(),
	}
	
	table.insert(self.db.todos, todo)
	self.nextId = self.nextId + 1
	self.db.nextId = self.nextId
	
	return todo.id
end

-- Update a todo
function CRAFTER_TODO:UpdateTodo(id, title, todoType, category)
	for _, todo in ipairs(self.db.todos) do
		if todo.id == id then
			if title then
				todo.title = title
			end
			if todoType then
				todo.type = todoType
			end
			if category then
				todo.category = category
			end
			todo.updatedAt = time()
			return true
		end
	end
	return false
end

-- Delete a todo
function CRAFTER_TODO:DeleteTodo(id)
	for i, todo in ipairs(self.db.todos) do
		if todo.id == id then
			table.remove(self.db.todos, i)
			return true
		end
	end
	return false
end

-- Get a todo by ID
function CRAFTER_TODO:GetTodo(id)
	for _, todo in ipairs(self.db.todos) do
		if todo.id == id then
			return todo
		end
	end
	return nil
end

-- Get all todos
function CRAFTER_TODO:GetAllTodos()
	return self.db.todos
end

-- Add material to a todo
function CRAFTER_TODO:AddMaterial(todoId, materialName, quantity, itemId)
	local todo = self:GetTodo(todoId)
	if todo then
		local material = {
			name = materialName or "Unknown Material",
			quantity = tonumber(quantity) or 1,
			itemId = itemId or 0,
			owned = 0,
		}
		table.insert(todo.materials, material)
		todo.updatedAt = time()
		return true
	end
	return false
end

-- Add or update material quantity to prevent duplicates
function CRAFTER_TODO:AddOrUpdateMaterial(todoId, materialName, quantity, itemId)
	local todo = self:GetTodo(todoId)
	if not todo then
		return false
	end

	local newQuantity = tonumber(quantity) or 1
	for _, material in ipairs(todo.materials) do
		local matchesId = itemId and itemId > 0 and material.itemId == itemId
		local matchesName = material.name == materialName
		if matchesId or matchesName then
			material.quantity = (material.quantity or 0) + newQuantity
			todo.updatedAt = time()
			return true
		end
	end

	return self:AddMaterial(todoId, materialName, newQuantity, itemId)
end

-- Remove material from a todo
function CRAFTER_TODO:RemoveMaterial(todoId, materialIndex)
	local todo = self:GetTodo(todoId)
	if todo and todo.materials[materialIndex] then
		table.remove(todo.materials, materialIndex)
		todo.updatedAt = time()
		return true
	end
	return false
end

-- Update material quantity
function CRAFTER_TODO:UpdateMaterialQuantity(todoId, materialIndex, newQuantity)
	local todo = self:GetTodo(todoId)
	if todo and todo.materials[materialIndex] then
		todo.materials[materialIndex].quantity = tonumber(newQuantity) or 1
		todo.updatedAt = time()
		return true
	end
	return false
end

-- Toggle todo completion status
function CRAFTER_TODO:ToggleTodoCompletion(id)
	local todo = self:GetTodo(id)
	if todo then
		todo.completed = not todo.completed
		todo.updatedAt = time()
		return true
	end
	return false
end

-- Save window position
function CRAFTER_TODO:SaveWindowPosition(x, y, width, height)
	self.db.settings.windowX = x
	self.db.settings.windowY = y
	self.db.settings.windowWidth = width
	self.db.settings.windowHeight = height
end

-- Get window position
function CRAFTER_TODO:GetWindowPosition()
	return {
		x = self.db.settings.windowX,
		y = self.db.settings.windowY,
		width = self.db.settings.windowWidth,
		height = self.db.settings.windowHeight,
	}
end

-- Set show on login
function CRAFTER_TODO:SetShowOnLogin(show)
	self.db.settings.showOnLogin = show
end

-- Get show on login
function CRAFTER_TODO:GetShowOnLogin()
	return self.db.settings.showOnLogin
end

-- Get available categories
function CRAFTER_TODO:GetCategories()
	return self.db.settings.categories or {"General"}
end

-- Build aggregated shopping list for all materials todos
function CRAFTER_TODO:GetShoppingList(categoryFilter)
	local summary = {}
	local order = {}
	local useFilter = categoryFilter and categoryFilter ~= "All"

	for _, todo in ipairs(self.db.todos) do
		if todo.type == "materials" and not todo.completed then
			if not useFilter or todo.category == categoryFilter then
				for _, material in ipairs(todo.materials) do
					local key = (material.itemId and material.itemId > 0) and tostring(material.itemId) or material.name
					if key then
						if not summary[key] then
							summary[key] = {
								itemId = material.itemId or 0,
								name = material.name or "Unknown",
								required = 0,
								owned = material.owned or 0,
							}
							table.insert(order, summary[key])
						end
						summary[key].required = summary[key].required + (material.quantity or 0)
						summary[key].owned = math.max(summary[key].owned, material.owned or 0)
					end
				end
			end
		end
	end

	table.sort(order, function(a, b)
		return (a.name or "") < (b.name or "")
	end)

	return order
end
-- Save minimap button position
function CRAFTER_TODO:SaveMinimapButtonPosition(point, relativeFrame, relativePoint, x, y)
	self.db.settings.minimapButtonPosition = {
		point = point or "TOPLEFT",
		relativePoint = relativePoint or "TOPLEFT",
		x = x or -5,
		y = y or 5,
	}
end

-- Get minimap button position
function CRAFTER_TODO:GetMinimapButtonPosition()
	return self.db.settings.minimapButtonPosition
end

-- Set show minimap button
function CRAFTER_TODO:SetShowMinimapButton(show)
	self.db.settings.showMinimapButton = show
	CRAFTER_TODO_UI:ToggleMinimapButton(show)
end

-- Get show minimap button
function CRAFTER_TODO:GetShowMinimapButton()
	return self.db.settings.showMinimapButton
end