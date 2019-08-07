local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local weak = { __mode='kv' }

local backgroundGroup
local background = {}
setmetatable(background, weak)

local UIGroup
local UI = {}
setmetatable(UI, weak)

local nextStep = ''


local function Resume(event)
    nextStep = 'resume'
    composer.hideOverlay('fade', 300)
end

local function backToMenu(event)
    nextStep = 'menu'
    print(composer.getSceneName('previous'))
    composer.gotoScene('menu', { time=500, effect='crossFade' })
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
    
    background['bgRect'] = display.newRoundedRect(
        backgroundGroup, centerX, centerY, width - 50, height - 50, 20)
    background['bgRect']:setFillColor(0.8, 0.8, 0.8)
    
    UI['PauseText'] = display.newText{ parent=UIGroup, text='Pause', x=centerX,
        y=centerY - 200, font=composer.getVariable('UIFont'), fontSize=72 }
    UI['PauseText']:setFillColor(0.3, 0.3, 0.3)
    
    UI['Resume'] = display.newRoundedRect(UIGroup, centerX, centerY, width * 2 / 3, 100, 10)
    UI['Resume']:setFillColor(1, 0.8, 0.5)
    UI['Resume']:addEventListener('tap', Resume)
    UI['ResumeText'] = display.newText{ parent=UIGroup, text='Resume', x=centerX,
        y=centerY-1, font=composer.getVariable('UIFont'), fontSize=48 }
    UI['ResumeText']:setFillColor(0.9, 0.5, 0.2)
    
    UI['Menu'] = display.newRoundedRect(UIGroup, centerX, centerY + 100, width / 2, 60, 8)
    UI['Menu']:setFillColor(0.6, 0.65, 0.7)
    UI['Menu']:addEventListener('tap', backToMenu)
    UI['MenuText'] = display.newText{ parent=UIGroup, text='Menu', x=centerX,
        y=centerY+99, font=composer.getVariable('UIFont'), fontSize=36 }
    UI['MenuText']:setFillColor(0.3, 0.35, 0.4)
    
    
    UI['Help'] = display.newRoundedRect(UIGroup, centerX, centerY + 180, width / 2, 60, 8)
    UI['Help']:setFillColor(0.6, 0.7, 0.6)
    UI['HelpText'] = display.newText{ parent=UIGroup, text='Help', x=centerX,
        y=centerY+179, font=composer.getVariable('UIFont'), fontSize=36 }
    UI['HelpText']:setFillColor(0.3, 0.4, 0.3)
    
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
    local parent = event.parent
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        if nextStep == 'resume' then
            parent:Resume()
        end
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