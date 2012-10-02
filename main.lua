-- require("debugger")()
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local storyboard = require "storyboard"

-- event listeners for tab buttons:
local function onFirstView( event )
	storyboard.gotoScene( "users" )
end

local function onSecondView( event )
	storyboard.gotoScene( "new_user" )
end

-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ label="Users", up="icon1.png", down="icon1-down.png", width = 32, height = 32, onPress=onFirstView, selected=true },
	{ label="New User", up="icon2.png", down="icon2-down.png", width = 32, height = 32, onPress=onSecondView }
}

-- create the actual tabBar widget
storyboard.tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}

onFirstView()	-- invoke first tab button's onPress event manually
