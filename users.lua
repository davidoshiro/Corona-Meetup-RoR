-----------------------------------------------------------------------------------------
--
-- members.lua
--
-----------------------------------------------------------------------------------------
local widget = require("widget")
local storyboard = require( "storyboard" )
local json = require("json")
local scene = storyboard.newScene()
local gotData = false
local data

-- Compile row
local function onAddTableRow(e)
	local row = e.target
	local rowGroup = e.view
	local text = display.newText(data[e.index].first_name .. " " .. data[e.index].last_name, 10, 0, "Helvetica-Bold", 18)
	print("onAddTableRow", e.index)
	text:setReferencePoint(display.CenterLeftReferencePoint)
	text:setTextColor(0)
	text.y = row.height * 0.5
	rowGroup:insert(text)
end

-- Add a new row to TableView
local function addTableRow()
	-- Add rows to list
	rowHeight = 54
	list:insertRow{						-- add a new row to TableView
		onRender = onAddTableRow,
		height = rowHeight
	}
end

-- Download data listener
local function onGetData(e)
	local msg
	data = json.decode(e.response)
	print("onGetData " .. #data)
	gotData = true
end

-- Download users
local function getData()
	gotData = false
	local url = "http://localhost:3000/users.json"
	print("getData: request data from " .. url)
	network.request(url, 'GET', onGetData)
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- Move tabBar back on screen
	storyboard.tabBar.x = display.contentWidth/2

	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight-49 )
	bg:setFillColor( 255 )	-- white
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- Initialize tableView
	local listOptions = {
		top = display.statusBarHeight,
		height = 360
		-- maskFile = "listItemBg.png"
	}
	list = widget.newTableView(listOptions)
	
	-- Get data
	getData()
	
	-- Screen listener
	local function usersSceneHandler(e) 
		if gotData then
			for i,v in ipairs(data) do
				print("usersSceneHandler", "Add row " .. i .. " of " .. #data)
				addTableRow()
			end
			gotData = false
		end
	end
	Runtime:addEventListener("enterFrame", usersSceneHandler )
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	list:deleteAllRows()
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc. )

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
