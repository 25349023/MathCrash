local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local card = require 'card'
local character = require 'character'

local weakMeta = { __mode='kv' }

local backgroundGroup
local backgrounds = {}
setmetatable(backgrounds, weakMeta)

local UIGroup
local UI = {}
setmetatable(UI, weakMeta)

local cardsOption = {
    width=542,
    height=862,
    numFrames=16
}
local cardSheet = graphics.newImageSheet("images/cards/cards.png", cardsOption)

local CardGroup
local cardImage = {}
setmetatable(cardImage, weakMeta)

local player
local opponent

local timeLeft = 3

local function chooseCard()
    local chosen = nil
    
    return function(event)
        if chosen then
            chosen.stroke = nil
        end
        event.target.stroke = { 1, 0.5, 0 }
        event.target.strokeWidth = 10
        chosen = event.target
        return true
    end
end

local plChooseCardEvent = chooseCard()


local function shrinkTimer(event)
    local centerX, centerY = display.contentCenterX, display.contentCenterY
    UI['Timer'].x, UI['Timer'].y = centerX / 4 + 10, centerY + 80
    UI['Timer'].path.radius = 30
    UI['TimerText'].x, UI['TimerText'].y = UI['Timer'].x, UI['Timer'].y - 1
    UI['TimerText'].size = 36
    UI['TimerText'].text = 5
    transition.fadeIn(UI['Timer'], { time=500, transition=easing.inOutSine })
    transition.fadeIn(UI['TimerText'], { time=500, transition=easing.inOutSine })
end


local function CountDownReady(event)
    timeLeft = timeLeft - 1
    if timeLeft > 0 then
        UI['TimerText'].text = tostring(timeLeft)
    elseif timeLeft == 0 then
        UI['TimerText'].text = 'Ready'
        UI['TimerText'].size = 48
    else 
        UI['TimerText'].text = 'GO!'
        UI['TimerText'].size = 72
        transition.fadeOut(UI['Timer'], { delay=1000, transition=easing.inOutSine, time=500 })
        transition.fadeOut(UI['TimerText'], { delay=1000, transition=easing.inOutSine, time=500,
                onComplete=shrinkTimer })
    end
end


local function CountDownGaming(event)
    
    
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
    CardGroup = display.newGroup()
    UIGroup = display.newGroup()
    
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(CardGroup)
    sceneGroup:insert(UIGroup)
    
    backgrounds['bgRect'] = display.newRect(backgroundGroup, centerX, centerY, width, height)
    backgrounds['bgRect'].fill = { 1, 1, 0.9 }
    
    
    player = character.Character:new{ currPoint=math.random(10) }
    player:init(CardGroup, cardSheet)
    player:shuffleDeck()
    
    opponent = character.Character:new{ currPoint=math.random(10) }
    opponent:init(CardGroup, cardSheet, true)
    opponent:shuffleDeck()
    
    -- draw init card
    print('player init point: ' .. player.currPoint)
    player:dealCards(centerX, centerY + 200, plChooseCardEvent)
    print('opponent init point: ' .. opponent.currPoint)
    opponent:dealCards(centerX, centerY - 200)
    
    UI['playerPoint'] = display.newText{ parent=UIGroup, text=player.currPoint, x=centerX, y=centerY+50,
        font=composer.getVariable("GameFont"), fontSize=72 }
    UI['playerPoint']:setFillColor(0.2, 0.2, 0.4)
    UI['opponentPoint'] = display.newText{ parent=UIGroup, text=opponent.currPoint, x=centerX, 
        y=centerY-50, font=composer.getVariable("GameFont"), fontSize=72 }
    UI['opponentPoint']:setFillColor(0.4, 0.2, 0.2)
    UI['midfieldLine'] = display.newLine(UIGroup, centerX - 75, centerY, centerX + 75, centerY)
    UI['midfieldLine']:setStrokeColor(0.6, 0.6, 0.6)
    
    UI['Timer'] = display.newCircle(UIGroup, centerX, centerY, 80)
    UI['Timer']:setFillColor(0.7, 0.9, 1)
    UI['Timer'].stroke = {0.6, 0.8, 0.9}
    UI['Timer'].strokeWidth = 10
    UI['Timer'].alpha = 0
    UI['TimerText'] = display.newText{ parent=UIGroup, text=timeLeft, x=UI['Timer'].x,
        y=UI['Timer'].y-2, font=composer.getVariable('UIFont'), fontSize=72 }
    UI['TimerText']:setFillColor(1, 1, 1)
    UI['TimerText'].alpha = 0
    
    --[[
    UI['Timer'] = display.newCircle(UIGroup, centerX / 4 + 10, centerY + 80, 30)
    UI['Timer']:setFillColor(0.7, 0.9, 1)
    UI['Timer'].stroke = {0.6, 0.8, 0.9}
    UI['Timer'].strokeWidth = 10
    UI['TimerText'] = display.newText{ parent=UIGroup, text=timeLeft, x=UI['Timer'].x, y=UI['Timer'].y-2,
        font=composer.getVariable('UIFont'), fontSize=44 }
    UI['TimerText']:setFillColor(1, 1, 1)
    --]]
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local tm = timer.performWithDelay(1000, CountDownReady, timeLeft + 1)
        timer.pause(tm)
        transition.to(UI['TimerText'], { time=500, transition=easing.outCubic, alpha=1 })
        transition.to(UI['Timer'], { time=500, transition=easing.outCubic, alpha=0.9,
                onComplete=function() timer.resume(tm); UI['TimerText'].alpha=1 end })
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