-----------------------------------------------------------------------------------------
--
-- topics.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")
local storyboard = require( "storyboard" )
local json = require("json")
local scene = storyboard.newScene()
local data
local dataSaved = false
local form = {}
local users = {first_name=nil, last_name=nil, email=nil}
local hasPut = false

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------
function fieldHandler(name, getObj)
	return function(e)
		print("fieldHandler: " .. name)
		if e.phase == "began" then
			print("onField: began")
		elseif e.phase == "ended" then
			print("onField: ended")
		elseif e.phase == "submitted" then
			users[name] = getObj().text
			print("onField: submit")
		end
	end
end

function createForm()
	local padding = 10
	local x = 10
	local rowHeight = 70
	local y = rowHeight
	local font = native.Font
	local fontSize = 14
	local fieldWidth = 300

	local label1 = display.newRetinaText( "First Name:", 0, 0, native.systemFont, 18)
	label1:setTextColor( 0 )	-- black
	label1:setReferencePoint( display.TopLeftReferencePoint )
	label1.x = x
	label1.y = y-25
	form.first_name = native.newTextField(x, y, fieldWidth, 28)
	form.first_name.size = fontSize
	form.first_name:addEventListener('userInput', fieldHandler("first_name", function() return form.first_name end))
	y = y + rowHeight

	local label2 = display.newRetinaText( "Last Name:", x, y-10, native.systemFont, 18)
	label2:setTextColor( 0 )	-- black
	label2:setReferencePoint( display.TopLeftReferencePoint )
	label2.x = x
	label2.y = y-25
	form.last_name = native.newTextField(x, y, fieldWidth, 28)
	form.last_name.size = fontSize
	form.last_name:addEventListener('userInput', fieldHandler("last_name", function() return form.last_name end))
	y = y + rowHeight

	local label3 = display.newRetinaText( "Email:", x, y-10, native.systemFont, 18)
	label3:setTextColor( 0 )	-- black
	label3:setReferencePoint( display.TopLeftReferencePoint )
	label3.x = x
	label3.y = y-25
	form.email = native.newTextField(x, y, fieldWidth, 28)
	form.email.size = fontSize
	form.email:addEventListener('userInput', fieldHandler("email", function() return form.email end))
	y = y + rowHeight

end

function scene:createScene( event )
	local group = self.view
end

-- Handler that gets notified when the alert closes
function onComplete( event )
	if "clicked" == event.action then
		local i = event.index
		if 1 == i then
			storyboard.gotoScene("new_user")
		end
	end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	createForm()

	-- Network listener
	local function networkListener(e)
		if ( e.isError ) then
			print( "Network error!")
			local alert = native.showAlert( "Error", "Network Error", { "OK" }, onComplete )
		else
			print ( "RESPONSE: " .. tostring(event.response) )
			-- Show alert with two buttons
			local alert = native.showAlert( "Add User", "Success!", { "OK" }, onComplete )
		end
	end

	-- Event listener for myButton
	local onButtonEvent = function (event )
		print( "You pressed and released a button!" )
		-- Setup table to mimic rails params format
		local results = {users=nil}
		results.users = users
		local url = "http://localhost:3000/users"
		print("-------------------------------------------------------------------------------------------")
		print(tostring(json.encode(results)))
		print("-------------------------------------------------------------------------------------------")
		headers = {}

		headers["Content-Type"] = "application/json"
		headers["Accept-Language"] = "en-US"

		body = json.encode(users)

		local params = {}
		params.headers = headers
		params.body = body
		network.request(url, 'POST', networkListener, params)
		hasPut = false
	end

	-- Create submit button
	local myButton = widget.newButton{
		id = "btn001",
		left = 100,
		top = 200,
		label = "Widget Button",
		width = 150, height = 28,
		cornerRadius = 8,
		onRelease = onButtonEvent
	}
	myButton.x = (display.contentWidth/2) - 75
	myButton.y = 300

	-- Change the button's label text:
	myButton:setLabel( "My Button" )

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	for k,v in pairs(form) do
		form[k]:removeSelf()
		form[k] = nil
	end
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)

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