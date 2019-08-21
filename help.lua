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


local function switchOverlay()
    composer.hideOverlay('slideLeft', 250)
    timer.performWithDelay(300, function (event)
            composer.showOverlay('options', { time=250, effect='fromLeft' })
        end)
end

local function backtoPrevScene()
    if composer.getSceneName('overlay') then
        switchOverlay()
    else
        local scname = composer.getSceneName('previous')
        composer.gotoScene(scname, { effect='slideLeft', time=400 })
    end
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
    UIGroup = display.newGroup()
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(UIGroup)
    
    backgrounds['bgRect'] = display.newRect(backgroundGroup, 
        centerX, centerY, width, height)
    backgrounds['bgRect']:setFillColor(1, 1, 0.9)
    
    UI['title'] = display.newText{ parent=UIGroup, x=centerX, y=50, text='How to Play',
        font=composer.getVariable('UIFont'), fontSize=36 }
    UI['title']:setFillColor(0.2, 0.5, 0.3)
    
    UI['back'] = display.newRoundedRect(UIGroup, centerX, height - 80, width / 2,
        60, 8)
    UI['back']:setFillColor(0.5, 0.3, 0.2)
    UI['backText'] = display.newText{ parent=UIGroup, x=centerX, y=height-80,
        text='Back', font=composer.getVariable('UIFont'), fontSize=36 }
    UI['backText']:setFillColor(1, 1, 1)
    
    UI['back']:addEventListener('tap', backtoPrevScene)
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        print(composer.getSceneName('previous'))
        print(composer.getSceneName('overlay'))
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