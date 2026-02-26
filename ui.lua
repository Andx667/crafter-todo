-- Crafter Todo - UI Management

CRAFTER_TODO_UI = {
	mainFrame = nil,
	todoListFrame = nil,
	shoppingListFrame = nil,
	editFrame = nil,
	minimapButton = nil,
	tradeSkillButton = nil,
	isVisible = false,
	selectedTodoId = nil,
	selectedCategory = "All",
	activePanel = "todos",
	todoFrames = {},
	shoppingRowFrames = {},
}

-- Create the main window
function CRAFTER_TODO_UI:CreateMainFrame()
	if self.mainFrame then
		return self.mainFrame
	end
	
	local pos = CRAFTER_TODO:GetWindowPosition()
	
	-- Main Frame
	local frame = CreateFrame("Frame", "CrafterTodoMainFrame", UIParent)
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	frame:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
	frame:SetBackdropBorderColor(0.6, 0.6, 0.6)
	frame:SetSize(pos.width, pos.height)
	frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", pos.x, -pos.y)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relativePoint, x, y = self:GetPoint()
		CRAFTER_TODO:SaveWindowPosition(x, -y, self:GetWidth(), self:GetHeight())
	end)
	
	-- Title Bar
	local titleBar = CreateFrame("Frame", nil, frame)
	titleBar:SetSize(frame:GetWidth(), 30)
	titleBar:SetPoint("TOPLEFT", 0, 0)
	titleBar:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 1,
	})
	titleBar:SetBackdropColor(0.2, 0.5, 0.8, 0.8)
	titleBar:SetBackdropBorderColor(0.6, 0.6, 0.6)
	
	-- Title Text
	local titleIcon = titleBar:CreateTexture(nil, "ARTWORK")
	titleIcon:SetSize(16, 16)
	titleIcon:SetPoint("LEFT", titleBar, "LEFT", 8, 0)
	titleIcon:SetTexture("Interface\\AddOns\\CrafterTodo\\img\\Copilot_20260226_140625.tga")

	local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titleText:SetPoint("LEFT", titleIcon, "RIGHT", 6, 0)
	titleText:SetText(CRAFTER_TODO_GetString("addon_name"))
	
	-- Close Button
	local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
	closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -5, 0)
	closeBtn:SetScript("OnClick", function()
		CRAFTER_TODO_UI:ToggleMainWindow()
	end)
	
	-- Tabs
	local todosTab = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	todosTab:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -35)
	todosTab:SetSize(90, 20)
	todosTab:SetText(CRAFTER_TODO_GetString("todos_tab"))
	todosTab:SetScript("OnClick", function()
		CRAFTER_TODO_UI.activePanel = "todos"
		CRAFTER_TODO_UI:UpdatePanelVisibility()
	end)

	local shoppingTab = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	shoppingTab:SetPoint("LEFT", todosTab, "RIGHT", 5, 0)
	shoppingTab:SetSize(120, 20)
	shoppingTab:SetText(CRAFTER_TODO_GetString("shopping_tab"))
	shoppingTab:SetScript("OnClick", function()
		CRAFTER_TODO_UI.activePanel = "shopping"
		CRAFTER_TODO_UI:UpdatePanelVisibility()
	end)

	-- Category Filter
	local categoryLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	categoryLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -58)
	categoryLabel:SetText(CRAFTER_TODO_GetString("category") .. ":")

	local categoryDropdown = CreateFrame("Frame", "CrafterTodoCategoryDropdown", frame, "UIDropDownMenuTemplate")
	categoryDropdown:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, -75)
	UIDropDownMenu_SetWidth(categoryDropdown, 160)
	UIDropDownMenu_SetText(categoryDropdown, CRAFTER_TODO_GetString("all_categories"))

	UIDropDownMenu_Initialize(categoryDropdown, function(_, level)
		local info = UIDropDownMenu_CreateInfo()
		info.text = CRAFTER_TODO_GetString("all_categories")
		info.func = function()
			CRAFTER_TODO_UI.selectedCategory = "All"
			UIDropDownMenu_SetText(categoryDropdown, CRAFTER_TODO_GetString("all_categories"))
			CRAFTER_TODO_UI:RefreshTodoList()
			CRAFTER_TODO_UI:RefreshShoppingList()
		end
		UIDropDownMenu_AddButton(info, level)

		for _, category in ipairs(CRAFTER_TODO:GetCategories()) do
			local catInfo = UIDropDownMenu_CreateInfo()
			catInfo.text = category
			catInfo.func = function()
				CRAFTER_TODO_UI.selectedCategory = category
				UIDropDownMenu_SetText(categoryDropdown, category)
				CRAFTER_TODO_UI:RefreshTodoList()
				CRAFTER_TODO_UI:RefreshShoppingList()
			end
			UIDropDownMenu_AddButton(catInfo, level)
		end
	end)

	-- Scroll Frame for Todos
	local todoScrollFrame = CreateFrame("ScrollFrame", "CrafterTodoScrollFrame", frame, "UIPanelScrollFrameTemplate")
	todoScrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -105)
	todoScrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)

	local todoListFrame = CreateFrame("Frame", nil, todoScrollFrame)
	todoListFrame:SetSize(todoScrollFrame:GetWidth() - 10, 20)
	todoScrollFrame:SetScrollChild(todoListFrame)

	-- Scroll Frame for Shopping List
	local shoppingScrollFrame = CreateFrame("ScrollFrame", "CrafterTodoShoppingScrollFrame", frame, "UIPanelScrollFrameTemplate")
	shoppingScrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -105)
	shoppingScrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)

	local shoppingListFrame = CreateFrame("Frame", nil, shoppingScrollFrame)
	shoppingListFrame:SetSize(shoppingScrollFrame:GetWidth() - 10, 20)
	shoppingScrollFrame:SetScrollChild(shoppingListFrame)
	shoppingScrollFrame:Hide()

	self.mainFrame = frame
	self.todoListFrame = todoListFrame
	self.shoppingListFrame = shoppingListFrame
	self.scrollFrame = todoScrollFrame
	self.shoppingScrollFrame = shoppingScrollFrame
	
	-- Add Todo Button
	local addBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	addBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	addBtn:SetSize(120, 25)
	addBtn:SetText(CRAFTER_TODO_GetString("add_todo"))
	addBtn:SetScript("OnClick", function()
		CRAFTER_TODO_UI:ShowEditFrame(nil)
	end)
	
	-- Settings Button
	local settingsBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	settingsBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
	settingsBtn:SetSize(120, 25)
	settingsBtn:SetText("Clear All")
	settingsBtn:SetScript("OnClick", function()
		if StaticPopup_Show("CRAFTER_TODO_CONFIRM_CLEAR") then
			-- Confirmation dialog shown
		end
	end)
	
	frame:Hide()
	return frame
end

-- Refresh the todo list display
function CRAFTER_TODO_UI:RefreshTodoList()
	-- Clear existing frames
	for _, frame in ipairs(self.todoFrames) do
		frame:Hide()
		frame:SetParent(nil)
	end
	self.todoFrames = {}
	
	local todos = CRAFTER_TODO:GetAllTodos()
	local yOffset = 0
	local hasSelected = false
	local useFilter = self.selectedCategory and self.selectedCategory ~= "All"
	
	if #todos == 0 then
		self.selectedTodoId = nil
		local emptyText = self.todoListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		emptyText:SetPoint("TOPLEFT", self.todoListFrame, "TOPLEFT", 10, -10)
		emptyText:SetText(CRAFTER_TODO_GetString("no_todos"))
		emptyText:SetTextColor(0.8, 0.8, 0.8)
		yOffset = 30
	else
		for _, todo in ipairs(todos) do
			if not useFilter or todo.category == self.selectedCategory then
				if todo.id == self.selectedTodoId then
					hasSelected = true
				end
				local todoFrame = self:CreateTodoFrame(todo, yOffset)
				table.insert(self.todoFrames, todoFrame)
				yOffset = yOffset + self:GetTodoFrameHeight(todo)
			end
		end
	end
	
	if #todos > 0 and yOffset == 0 then
		local emptyText = self.todoListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		emptyText:SetPoint("TOPLEFT", self.todoListFrame, "TOPLEFT", 10, -10)
		emptyText:SetText(CRAFTER_TODO_GetString("no_todos"))
		emptyText:SetTextColor(0.8, 0.8, 0.8)
		yOffset = 30
	end
	
	if self.selectedTodoId and not hasSelected then
		self.selectedTodoId = nil
	end
	self:UpdateTradeSkillButton()
	
	self.todoListFrame:SetHeight(math.max(yOffset, 20))
end

-- Update which panel is visible
function CRAFTER_TODO_UI:UpdatePanelVisibility()
	if self.activePanel == "shopping" then
		if self.scrollFrame then
			self.scrollFrame:Hide()
		end
		if self.shoppingScrollFrame then
			self.shoppingScrollFrame:Show()
		end
		self:RefreshShoppingList()
	else
		if self.shoppingScrollFrame then
			self.shoppingScrollFrame:Hide()
		end
		if self.scrollFrame then
			self.scrollFrame:Show()
		end
		self:RefreshTodoList()
	end
end

-- Refresh the shopping list display
function CRAFTER_TODO_UI:RefreshShoppingList()
	if not self.shoppingListFrame or not self.shoppingScrollFrame then
		return
	end

	for _, frame in ipairs(self.shoppingRowFrames) do
		frame:Hide()
		frame:SetParent(nil)
	end
	self.shoppingRowFrames = {}

	local items = CRAFTER_TODO:GetShoppingList(self.selectedCategory)
	local yOffset = 0

	if #items == 0 then
		local emptyText = self.shoppingListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		emptyText:SetPoint("TOPLEFT", self.shoppingListFrame, "TOPLEFT", 10, -10)
		emptyText:SetText(CRAFTER_TODO_GetString("no_shopping_items"))
		emptyText:SetTextColor(0.8, 0.8, 0.8)
		yOffset = 30
	else
		for _, item in ipairs(items) do
			local missing = math.max((item.required or 0) - (item.owned or 0), 0)
			if missing > 0 then
				local row = CreateFrame("Frame", nil, self.shoppingListFrame)
				row:SetSize(self.shoppingListFrame:GetWidth() - 20, 25)
				row:SetPoint("TOPLEFT", self.shoppingListFrame, "TOPLEFT", 10, -yOffset)
				row:SetBackdrop({
					bgFile = "Interface/Tooltips/UI-Tooltip-Background",
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = true,
					tileSize = 16,
					edgeSize = 1,
				})
				row:SetBackdropColor(0.15, 0.15, 0.15, 0.5)
				row:SetBackdropBorderColor(0.4, 0.4, 0.4)

				local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				nameText:SetPoint("LEFT", row, "LEFT", 8, 0)
				nameText:SetText(item.name or "Unknown")

				local countText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				countText:SetPoint("RIGHT", row, "RIGHT", -8, 0)
				countText:SetText(string.format("Need: %d (Own: %d)", missing, item.owned or 0))
				countText:SetTextColor(0.9, 0.9, 0.7)

				table.insert(self.shoppingRowFrames, row)
				yOffset = yOffset + 28
			end
		end
	end

	if #items > 0 and yOffset == 0 then
		local emptyText = self.shoppingListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		emptyText:SetPoint("TOPLEFT", self.shoppingListFrame, "TOPLEFT", 10, -10)
		emptyText:SetText(CRAFTER_TODO_GetString("no_shopping_items"))
		emptyText:SetTextColor(0.8, 0.8, 0.8)
		yOffset = 30
	end

	self.shoppingListFrame:SetHeight(math.max(yOffset, 20))
end

-- Create a button on the TradeSkill frame to add reagents
function CRAFTER_TODO_UI:CreateTradeSkillButton()
	if self.tradeSkillButton or not TradeSkillFrame then
		return
	end

	local button = CreateFrame("Button", "CrafterTodoAddRecipeButton", TradeSkillFrame, "GameMenuButtonTemplate")
	button:SetSize(140, 20)
	button:SetText(CRAFTER_TODO_GetString("add_recipe_materials"))
	if TradeSkillCreateButton then
		button:SetPoint("LEFT", TradeSkillCreateButton, "RIGHT", 6, 0)
	else
		button:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMLEFT", 70, 70)
	end
	button:SetScript("OnClick", function()
		CRAFTER_TODO_UI:AddSelectedRecipeToTodo()
	end)

	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Add reagents to selected todo", 1, 1, 1)
		GameTooltip:AddLine("Select a materials todo, then click this button", 0.9, 0.9, 0.9)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	self.tradeSkillButton = button
	self:UpdateTradeSkillButton()
end

-- Enable or disable the TradeSkill button based on selection
function CRAFTER_TODO_UI:UpdateTradeSkillButton()
	if not self.tradeSkillButton or not self.tradeSkillButton:IsVisible() then
		return
	end

	local selectedTodo = CRAFTER_TODO:GetTodo(self.selectedTodoId)
	local hasTodo = selectedTodo and selectedTodo.type == "materials"
	local index = GetTradeSkillSelectionIndex and GetTradeSkillSelectionIndex() or 0
	local _, tradeSkillType = GetTradeSkillInfo(index)
	if hasTodo and index and index > 0 and tradeSkillType ~= "header" then
		self.tradeSkillButton:Enable()
	else
		self.tradeSkillButton:Disable()
	end
end

-- Add reagents from the selected recipe to the current materials todo
function CRAFTER_TODO_UI:AddSelectedRecipeToTodo()
	local selectedTodo = CRAFTER_TODO:GetTodo(self.selectedTodoId)
	if not selectedTodo or selectedTodo.type ~= "materials" then
		print("|cffff0000Please select a materials-type todo first|r")
		return
	end

	local index = GetTradeSkillSelectionIndex and GetTradeSkillSelectionIndex() or 0
	if not index or index <= 0 then
		print("|cffff0000Please select a recipe first|r")
		return
	end

	local recipeName, tradeSkillType = GetTradeSkillInfo(index)
	if tradeSkillType == "header" then
		print("|cffff0000Please select a recipe, not a category header|r")
		return
	end

	local numReagents = GetTradeSkillNumReagents(index) or 0
	if numReagents == 0 then
		print("|cffff0000No reagents found for this recipe|r")
		return
	end

	for i = 1, numReagents do
		local name, _, count = GetTradeSkillReagentInfo(index, i)
		local link = GetTradeSkillReagentItemLink(index, i)
		local itemId = link and tonumber(string.match(link, "item:(%d+)")) or 0
		if name and count then
			CRAFTER_TODO:AddOrUpdateMaterial(selectedTodo.id, name, count, itemId)
		end
	end

	CRAFTER_TODO_UI:RefreshTodoList()
	CRAFTER_TODO_UI:RefreshShoppingList()
	print(string.format("|cff00ff00Added reagents for %s|r", recipeName or "recipe"))
end

-- Create a single todo frame
function CRAFTER_TODO_UI:CreateTodoFrame(todo, yOffset)
	local frame = CreateFrame("Frame", nil, self.todoListFrame)
	local height = self:GetTodoFrameHeight(todo)
	frame:SetSize(self.todoListFrame:GetWidth() - 20, height)
	frame:SetPoint("TOPLEFT", self.todoListFrame, "TOPLEFT", 10, -yOffset)
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 1,
	})

	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", function()
		CRAFTER_TODO_UI.selectedTodoId = todo.id
		CRAFTER_TODO_UI:RefreshTodoList()
		CRAFTER_TODO_UI:UpdateTradeSkillButton()
	end)
	
	local bgColor = todo.completed and {0.2, 0.3, 0.2, 0.5} or {0.15, 0.15, 0.15, 0.5}
	frame:SetBackdropColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
	if todo.id == self.selectedTodoId then
		frame:SetBackdropBorderColor(0.9, 0.8, 0.4)
	else
		frame:SetBackdropBorderColor(0.4, 0.4, 0.4)
	end
	
	-- Checkbox
	local checkbox = CreateFrame("CheckButton", nil, frame, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
	checkbox:SetChecked(todo.completed)
	checkbox:SetScript("OnClick", function(self)
		CRAFTER_TODO:ToggleTodoCompletion(todo.id)
		CRAFTER_TODO_UI:RefreshTodoList()
	end)
	
	-- Title Text
	local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleText:SetPoint("TOPLEFT", checkbox, "TOPRIGHT", 5, 0)
	titleText:SetWidth(frame:GetWidth() - 100)
	titleText:SetHeight(20)
	if todo.completed then
		titleText:SetTextColor(0.6, 0.6, 0.6)
	else
		titleText:SetTextColor(1, 1, 1)
	end
	local category = todo.category or "General"
	if category ~= "General" then
		titleText:SetText(string.format("%s (%s)", todo.title, category))
	else
		titleText:SetText(todo.title)
	end
	
	-- Edit Button
	local editBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	editBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, -2)
	editBtn:SetSize(40, 20)
	editBtn:SetText(CRAFTER_TODO_GetString("edit_todo"))
	editBtn:SetScript("OnClick", function()
		CRAFTER_TODO_UI:ShowEditFrame(todo.id)
	end)
	
	-- Delete Button
	local deleteBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	deleteBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -2)
	deleteBtn:SetSize(40, 20)
	deleteBtn:SetText(CRAFTER_TODO_GetString("delete_todo"))
	deleteBtn:SetScript("OnClick", function()
		StaticPopup_Show("CRAFTER_TODO_CONFIRM_DELETE", todo.title, nil, todo.id)
	end)
	
	-- Show materials if applicable
	if todo.type == "materials" and #todo.materials > 0 then
		local yPos = 25
		for i, material in ipairs(todo.materials) do
			local matText = frame:CreateFontString(nil, "OVERLAY", "GameFontSmall")
			matText:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -yPos)
			matText:SetText(string.format("  • %s x%d (Own: %d)", material.name, material.quantity, material.owned or 0))
			matText:SetTextColor(0.9, 0.9, 0.7)
			yPos = yPos + 15
		end
	end
	
	return frame
end

-- Get the height needed for a todo frame
function CRAFTER_TODO_UI:GetTodoFrameHeight(todo)
	if todo.type == "materials" then
		return 25 + (#todo.materials * 15)
	end
	return 25
end

-- Show the edit/create frame
function CRAFTER_TODO_UI:ShowEditFrame(todoId)
	if self.editFrame then
		self.editFrame:Hide()
	end
	
	local todo = todoId and CRAFTER_TODO:GetTodo(todoId) or nil
	local isNew = not todo
	
	local frame = CreateFrame("Frame", "CrafterTodoEditFrame", UIParent)
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	frame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
	frame:SetBackdropBorderColor(0.6, 0.6, 0.6)
	frame:SetSize(350, 280)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	-- Title Bar
	local titleBar = CreateFrame("Frame", nil, frame)
	titleBar:SetSize(frame:GetWidth(), 25)
	titleBar:SetPoint("TOPLEFT", 0, 0)
	titleBar:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
	titleBar:SetBackdropColor(0.2, 0.5, 0.8, 0.8)
	
	local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleText:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
	titleText:SetText(isNew and CRAFTER_TODO_GetString("new_todo") or "Edit Todo")
	
	local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
	closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -5, 0)
	closeBtn:SetScript("OnClick", function() frame:Hide() frame:SetParent(nil) end)
	
	-- Title Input
	local titleLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -35)
	titleLabel:SetText("Title:")
	
	local titleInput = CreateFrame("EditBox", nil, frame)
	titleInput:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 5})
	titleInput:SetBackdropColor(0.1, 0.1, 0.1)
	titleInput:SetBackdropBorderColor(0.4, 0.4, 0.4)
	titleInput:SetSize(300, 25)
	titleInput:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -55)
	titleInput:SetFontObject(ChatFontNormal)
	titleInput:SetAutoFocus(false)
	if todo then
		titleInput:SetText(todo.title)
	end
	
	-- Type Selection
	local typeLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	typeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -90)
	typeLabel:SetText("Type:")
	
	local plainBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	plainBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -110)
	plainBtn:SetSize(100, 25)
	plainBtn:SetText(CRAFTER_TODO_GetString("plain_text"))
	plainBtn:SetScript("OnClick", function()
		frame.selectedType = "plain"
		plainBtn:Enable()
	end)
	
	local materialsBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	materialsBtn:SetPoint("LEFT", plainBtn, "RIGHT", 10, 0)
	materialsBtn:SetSize(100, 25)
	materialsBtn:SetText(CRAFTER_TODO_GetString("materials_list"))
	materialsBtn:SetScript("OnClick", function()
		frame.selectedType = "materials"
		materialsBtn:Enable()
	end)

	-- Category Selection
	local categoryLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	categoryLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -145)
	categoryLabel:SetText(CRAFTER_TODO_GetString("category") .. ":")

	local categoryDropdown = CreateFrame("Frame", "CrafterTodoEditCategoryDropdown", frame, "UIDropDownMenuTemplate")
	categoryDropdown:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, -162)
	UIDropDownMenu_SetWidth(categoryDropdown, 180)

	local categories = CRAFTER_TODO:GetCategories()
	frame.selectedCategory = todo and todo.category or (categories[1] or "General")
	UIDropDownMenu_SetText(categoryDropdown, frame.selectedCategory)

	UIDropDownMenu_Initialize(categoryDropdown, function(_, level)
		for _, category in ipairs(categories) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = category
			info.func = function()
				frame.selectedCategory = category
				UIDropDownMenu_SetText(categoryDropdown, category)
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end)
	
	-- Save Button
	local saveBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	saveBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	saveBtn:SetSize(100, 25)
	saveBtn:SetText(CRAFTER_TODO_GetString("save_todo"))
	saveBtn:SetScript("OnClick", function()
		local title = titleInput:GetText()
		if title == "" then title = "Unnamed Todo" end
		local todoType = frame.selectedType or "plain"
		local todoCategory = frame.selectedCategory or (categories[1] or "General")
		
		if isNew then
			CRAFTER_TODO:AddTodo(title, todoType, todoCategory)
		else
			CRAFTER_TODO:UpdateTodo(todoId, title, todoType, todoCategory)
		end
		
		CRAFTER_TODO_UI:RefreshTodoList()
		frame:Hide()
		frame:SetParent(nil)
	end)
	
	-- Cancel Button
	local cancelBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	cancelBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
	cancelBtn:SetSize(100, 25)
	cancelBtn:SetText(CRAFTER_TODO_GetString("cancel"))
	cancelBtn:SetScript("OnClick", function()
		frame:Hide()
		frame:SetParent(nil)
	end)
	
	frame.selectedType = todo and todo.type or "plain"
	self.editFrame = frame
end

-- Toggle main window visibility
function CRAFTER_TODO_UI:ToggleMainWindow()
	if not self.mainFrame then
		self:CreateMainFrame()
	end
	
	if self.mainFrame:IsVisible() then
		self.mainFrame:Hide()
		self.isVisible = false
	else
		self.mainFrame:Show()
		self.isVisible = true
		self:UpdatePanelVisibility()
	end
end

-- Show main window
function CRAFTER_TODO_UI:ShowWindow()
	if not self.mainFrame then
		self:CreateMainFrame()
	end
	self.mainFrame:Show()
	self.isVisible = true
	self:UpdatePanelVisibility()
end

-- Hide main window
function CRAFTER_TODO_UI:HideWindow()
	if self.mainFrame then
		self.mainFrame:Hide()
		self.isVisible = false
	end
end

-- Create minimap button
function CRAFTER_TODO_UI:CreateMinimapButton()
	if self.minimapButton then
		return self.minimapButton
	end
	
	-- Create minimap button frame
	local button = CreateFrame("Button", "CrafterTodoMinimapButton", Minimap)
	button:SetSize(33, 33)
	button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -5, 5)
	button:SetMovable(true)
	button:EnableMouse(true)
	button:RegisterForDrag("LeftButton")
	button:RegisterForClicks("AnyUp")
	
	-- Set button texture (using a simple basic texture and colored background)
	local texture = button:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(button)
	texture:SetColorTexture(0.3, 0.7, 1.0, 0.8)
	
	-- Add icon text
	local iconText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	iconText:SetPoint("CENTER", button, "CENTER", 0, 0)
	iconText:SetText("ToDo")
	iconText:SetTextColor(1, 1, 1)
	
	-- Set up backdrop for better appearance
	button:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 1,
		insets = {left = 2, right = 2, top = 2, bottom = 2}
	})
	button:SetBackdropColor(0.3, 0.7, 1.0, 0.7)
	button:SetBackdropBorderColor(0.6, 0.8, 1.0, 0.9)
	
	-- Button click handler
	button:SetScript("OnClick", function(self, mouseButton)
		if mouseButton == "LeftButton" then
			CRAFTER_TODO_UI:ToggleMainWindow()
		end
	end)
	
	-- Drag handler
	button:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	
	button:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		CRAFTER_TODO:SaveMinimapButtonPosition(self:GetPoint())
	end)
	
	-- Tooltip
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Crafter Todo", 1, 1, 1)
		GameTooltip:AddLine("Left-click to open todo list", 0.9, 0.9, 0.9)
		GameTooltip:Show()
	end)
	
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	-- Restore position if saved
	local savedPos = CRAFTER_TODO:GetMinimapButtonPosition()
	if savedPos then
		button:SetPoint(savedPos.point, Minimap, savedPos.relativePoint, savedPos.x, savedPos.y)
	end
	
	self.minimapButton = button
	return button
end

-- Show minimap button
function CRAFTER_TODO_UI:ShowMinimapButton()
	if not self.minimapButton then
		self:CreateMinimapButton()
	end
	self.minimapButton:Show()
end

-- Hide minimap button
function CRAFTER_TODO_UI:HideMinimapButton()
	if self.minimapButton then
		self.minimapButton:Hide()
	end
end

-- Toggle minimap button visibility
function CRAFTER_TODO_UI:ToggleMinimapButton(show)
	if show == nil then
		show = CRAFTER_TODO:GetShowMinimapButton()
	end
	
	if show then
		self:ShowMinimapButton()
	else
		self:HideMinimapButton()
	end
end
