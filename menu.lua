local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local weakMeta = { __mode='kv' }

local backgroundGroup
local backgrounds = {}
setmetatable(backgrounds, weakMeta)

local UIGroup
local UI = {}
setmetatable(UI, weakMeta)


function switchToGame()
    composer.gotoScene('game', { effect='fade', time=600 })
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY
    local width = display.contentWidth
    local height = display.contentHeight
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    backgroundGroup = display.newGroup()
    sceneGroup:insert(backgroundGroup)
    backgrounds['bgRect'] = display.newRect(backgroundGroup, centerX, centerY, width, height)
    backgrounds['bgRect'].fill = { 1, 1, 0.9 }
    
    UIGroup = display.newGroup()
    sceneGroup:insert(UIGroup)
    -- local fillC = { default=, over={0.5, 0.7, 1} }
    UI['start'] = display.newRoundedRect(UIGroup, centerX, centerY+100, width*2/3, 100, 10)
    UI['start']:setFillColor(0.4, 0.6, 1)
    UI['startText'] = display.newText{ parent=UIGroup, x=centerX, y=centerY+100, text='Start',
        font='SourceSansPro-Black.ttf', fontSize=48 }
    UI['startText']:setFillColor(1, 1, 1)
    
    UI['start']:addEventListener('tap', switchToGame)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        --[[
        local native = require("native")
        for _, n in ipairs(native.getFontNames()) do
            print(n)
        end
        --]]
        
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene