-- Crafter Todo - UI Management

CRAFTER_TODO_UI = {
	mainFrame = nil,
	todoListFrame = nil,
	editFrame = nil,
	minimapButton = nil,
	isVisible = false,
	selectedTodoId = nil,
	todoFrames = {},
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
	
	-- Scroll Frame for Todos
	local scrollFrame = CreateFrame("ScrollFrame", "CrafterTodoScrollFrame", frame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
	scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)
	
	local listFrame = CreateFrame("Frame", nil, scrollFrame)
	listFrame:SetSize(scrollFrame:GetWidth() - 10, 20)
	scrollFrame:SetScrollChild(listFrame)
	
	self.mainFrame = frame
	self.todoListFrame = listFrame
	self.scrollFrame = scrollFrame
	
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
	
	if #todos == 0 then
		self.selectedTodoId = nil
		local emptyText = self.todoListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		emptyText:SetPoint("TOPLEFT", self.todoListFrame, "TOPLEFT", 10, -10)
		emptyText:SetText(CRAFTER_TODO_GetString("no_todos"))
		emptyText:SetTextColor(0.8, 0.8, 0.8)
		yOffset = 30
	else
		for _, todo in ipairs(todos) do
			if todo.id == self.selectedTodoId then
				hasSelected = true
			end
			local todoFrame = self:CreateTodoFrame(todo, yOffset)
			table.insert(self.todoFrames, todoFrame)
			yOffset = yOffset + self:GetTodoFrameHeight(todo)
		end
	end
	
	if self.selectedTodoId and not hasSelected then
		self.selectedTodoId = nil
	end
	
	self.todoListFrame:SetHeight(math.max(yOffset, 20))
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
	titleText:SetText(todo.title)
	
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
	
	-- Save Button
	local saveBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
	saveBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	saveBtn:SetSize(100, 25)
	saveBtn:SetText(CRAFTER_TODO_GetString("save_todo"))
	saveBtn:SetScript("OnClick", function()
		local title = titleInput:GetText()
		if title == "" then title = "Unnamed Todo" end
		local todoType = frame.selectedType or "plain"
		
		if isNew then
			CRAFTER_TODO:AddTodo(title, todoType)
		else
			CRAFTER_TODO:UpdateTodo(todoId, title, todoType)
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
		self:RefreshTodoList()
	end
end

-- Show main window
function CRAFTER_TODO_UI:ShowWindow()
	if not self.mainFrame then
		self:CreateMainFrame()
	end
	self.mainFrame:Show()
	self.isVisible = true
	self:RefreshTodoList()
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
