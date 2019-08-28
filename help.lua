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
    
    UI['help1'] = display.newImageRect(UIGroup, 'images/help/help1.png', 250, 250)
    UI['help1'].x, UI['help1'].y = centerX - 85, centerY - 100
    UI['help2'] = display.newImageRect(UIGroup, 'images/help/help2.png', 250, 250)
    UI['help2'].x, UI['help2'].y = centerX + 85, centerY - 100
    UI['help3'] = display.newImageRect(UIGroup, 'images/help/help3.png', 250, 250)
    UI['help3'].x, UI['help3'].y = centerX - 85, centerY + 85
    UI['help4'] = display.newImageRect(UIGroup, 'images/help/help4.png', 250, 250)
    UI['help4'].x, UI['help4'].y = centerX + 85, centerY + 85
    
    UI['cross'] = display.newImageRect(UIGroup, 'images/UI/cross.png', 256, 256)
    UI['cross'].x, UI['cross'].y = centerX, centerY
     
    UI['step1'] = display.newImageRect(UIGroup, 'images/UI/step1.png', 32, 32)
    UI['step1'].x = centerX - 16
    UI['step1'].y = centerY - 16
    UI['step2'] = display.newImageRect(UIGroup, 'images/UI/step2.png', 32, 32)
    UI['step2'].x = centerX + 16
    UI['step2'].y = centerY - 16
    UI['step3'] = display.newImageRect(UIGroup, 'images/UI/step3.png', 32, 32)
    UI['step3'].x = centerX - 16
    UI['step3'].y = centerY + 16
    UI['step4'] = display.newImageRect(UIGroup, 'images/UI/step4.png', 32, 32)
    UI['step4'].x = centerX + 16
    UI['step4'].y = centerY + 16
    
    
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