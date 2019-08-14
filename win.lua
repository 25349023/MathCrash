local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local backgroundGroup
local backgrounds = {}
setmetatable(backgrounds, { __mode='kv' })

local UIGroup
local UI = {}
setmetatable(UI, { __mode='kv' })


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
    local win = event.params['isWin']

    -- Code here runs when the scene is first created but has not yet appeared on screen
    backgroundGroup = display.newGroup()
    UIGroup = display.newGroup()
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(UIGroup)
    
    backgrounds['bgRect'] = display.newRect(backgroundGroup, centerX, centerY, width, height)
    backgrounds['bgRect'].fill = { 1, 1, 0.9 }
    
    UI['youText'] = display.newText{ parent=UIGroup, text='You', x=centerX,
        y=centerY-125, font=composer.getVariable('UIFont'), fontSize=54 }
    UI['youText']:setFillColor(1, 0.7, 0.2)
    
    local text = win and 'Win!!' or 'Lose...'
    UI['mainText'] = display.newText{ parent=UIGroup, text=text, x=centerX,
        y=centerY-60, font=composer.getVariable('UIFont'), fontSize=72 }
    UI['mainText']:setFillColor(1, 0.7, 0.2)
    
    UI['menu'] = display.newRoundedRect(UIGroup, centerX, centerY + 80,
        200, 80, 12)
    UI['menu']:setFillColor(0.75, 0.65, 0.55)
    UI['menu']:addEventListener('tap', function() 
            composer.gotoScene('menu', { effect='slideRight', time=500 }) end)
    UI['menuText'] = display.newText{ parent=UIGroup, text='Menu', x=centerX,
        y=centerY+80, font=composer.getVariable('UIFont'), fontSize=48 }
    UI['menuText']:setFillColor(1, 1, 1)
    
    
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
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
        composer.removeScene('win', true)
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