local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local card = require 'card'
local character = require 'character'
local ai = require 'ai'

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
-- local cardImage = {}
-- setmetatable(cardImage, weakMeta)

local player
local playerAI
local opponent

local stageSetting = { timeLimit=6 }

local timeLeft = 3

local gameLogic = { state='init', ready=0, opIdx=0, plIdx=0 }


local function adjustTimer()
    local centerX, centerY = display.contentCenterX, display.contentCenterY
    UI['Timer'].x, UI['Timer'].y = centerX / 4 + 10, centerY + 80
    UI['Timer'].path.radius = 30
    UI['Timer']:setFillColor(1, 0.7, 0.7)
    UI['Timer']:setStrokeColor(1, 0.42, 0.42)
    
    UI['TimerText'].x, UI['TimerText'].y = UI['Timer'].x, UI['Timer'].y - 1
    UI['TimerText'].size = 36
    UI['TimerText'].text = 5
    -- transition.fadeIn(UI['Timer'], { time=500, transition=easing.inOutSine })
    -- transition.fadeIn(UI['TimerText'], { time=500, transition=easing.inOutSine })
end


local function countDownReady(event)
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
                onComplete = function(event)
                    adjustTimer()
                    gameLogic:newRound()
                end })
    end
end

local function countDownGaming(event)
    timeLeft = timeLeft - 1
    if timeLeft == 5 then
        transition.fadeIn(UI['Timer'], { time=300, transition=easing.outSine })
        transition.fadeIn(UI['TimerText'], { time=300, transition=easing.outSine })
    end
    if timeLeft <= 5 then
        UI['TimerText'].text = timeLeft
    end
    if timeLeft <= 0 then
        print("time's up")
        transition.fadeOut(UI['Timer'], { delay=200, time=300, transition=easing.inOutSine })
        transition.fadeOut(UI['TimerText'], { delay=200, time=300, transition=easing.inOutSine })
        timer.performWithDelay(500, gameLogic:selectCard(playerAI:chooseCard()))
    end
end


local function clickCard()
    local chosen = nil
    
    return function (event)
        if gameLogic.state ~= 'playing' then
            return false
        end
        
        if chosen == event.target then
            local ind = assert(player:handCardIndex(event.target), "can't find target in handcard")
            gameLogic:selectCard(ind)
            gameLogic:stopTiming()
            return true
        end
        if chosen then
            chosen.stroke = nil
        end
        event.target.stroke = { 1, 0.5, 0 }
        event.target.strokeWidth = 10
        chosen = event.target
        return true
    end
end

local plOnClickCard = clickCard()


function gameLogic:prepare()
    self.state = 'prepare'
    self.ready = 0
    print 'player draw card'
    player:drawCard()
    print 'opponent draw card'
    opponent.role:drawCard()
    gameLogic:newRound()    
end

function gameLogic:newRound()
    local centerX, centerY = display.contentCenterX, display.contentCenterY
        
    timeLeft = stageSetting.timeLimit
    self.state = 'playing'
    self.tm = timer.performWithDelay(1000, countDownGaming, timeLeft)
    
    local ind = opponent:chooseCard()
    gameLogic.opIdx = ind
    transition.moveTo(opponent.role.handCard[ind].image, 
        { x=centerX - 100, y=centerY-50, time=800, delay=1000, transition=easing.inOutSine,
          onComplete=function() gameLogic:readyForOne() end })
    
end

function gameLogic:selectCard(ind)
    local centerX, centerY = display.contentCenterX, display.contentCenterY
    
    transition.moveTo(player.handCard[ind].image, 
        { x=centerX + 100, y=centerY+50, time=800, transition=easing.inOutSine,
            onComplete=function() self:readyForOne() end })
    player.handCard[ind].image.stroke = nil
    self.state = 'played'
    self.plIdx = ind
end

function gameLogic:calculateAndPK()
    local centerX, centerY = display.contentCenterX, display.contentCenterY
    local pid, oid = gameLogic.plIdx, gameLogic.opIdx
            
    transition.scaleTo(opponent.role.handCard[oid].image,
        { xScale=0.001, time=200, transition=easing.inOutSine,
            onComplete=function()
                local cd = opponent.role.handCard[oid]
                local x, y = cd.image.x, cd.image.y
                cd.image:removeSelf()
                cd.image = display.newImageRect(CardGroup, cardSheet, cd.imgIndex, 271, 431)
                cd.image:scale(0.001, 0.3)
                cd.image.x, cd.image.y = x, y
                transition.scaleTo(cd.image, 
                    { xScale=0.3, time=200, transition=easing.inOutSine })
            end })
    
    timer.performWithDelay(500,
        function() player:playCard(pid, centerX) end)
    timer.performWithDelay(500,
        function() opponent.role:playCard(oid, centerX) end)
    
    timer.performWithDelay(1200,
        function() UI['playerPoint'].text = player.currPoint end)
    timer.performWithDelay(1200,
        function() UI['opponentPoint'].text = opponent.role.currPoint end)
    
    timer.performWithDelay(1500, function() gameLogic:prepare() end)
end

function gameLogic:readyForOne()
    self.ready = self.ready + 1
    if self.ready == 2 then
        print('next stage')
        gameLogic:calculateAndPK()
    end
    
end

function gameLogic:stopTiming()
    timer.cancel(self.tm)
    transition.fadeOut(UI['Timer'], { delay=400, time=300, transition=easing.inOutSine })
    transition.fadeOut(UI['TimerText'], { delay=400, time=300, transition=easing.inOutSine })
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
    CardGroup = display.newGroup()
    
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(UIGroup)
    sceneGroup:insert(CardGroup)
    
    backgrounds['bgRect'] = display.newRect(backgroundGroup, centerX, centerY, width, height)
    backgrounds['bgRect'].fill = { 1, 1, 0.9 }
    
    
    player = character.Character:new{ currPoint=math.random(10), cx=centerX,
        y=centerY+200, CardGroup=CardGroup, cardSheet=cardSheet }
    playerAI = ai.RandomAI:new{ role=player }
    player:init(plOnClickCard)
    
    opponent = ai.RandomAI:new{ 
        role=character.Character:new{ currPoint=math.random(10), cx=centerX,
            y=centerY-200, hide=true, CardGroup=CardGroup, cardSheet=cardSheet } }
    opponent.role:init()
    
    -- draw init card
    print('player init point: ' .. player.currPoint)
    player:dealCards()
    print('opponent init point: ' .. opponent.role.currPoint)
    opponent.role:dealCards()
    
    UI['playerPoint'] = display.newText{ parent=UIGroup, text=player.currPoint, 
        x=centerX, y=centerY+50, font=composer.getVariable("GameFont"), fontSize=72 }
    UI['playerPoint']:setFillColor(0.2, 0.2, 0.4)
    UI['opponentPoint'] = display.newText{ parent=UIGroup, 
        text=opponent.role.currPoint, x=centerX, y=centerY-50,
        font=composer.getVariable("GameFont"), fontSize=72 }
    UI['opponentPoint']:setFillColor(0.4, 0.2, 0.2)
    UI['midfieldLine'] = display.newLine(UIGroup, centerX - 75, centerY,
            centerX + 75, centerY)
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
    

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local tm = timer.performWithDelay(1000, countDownReady, timeLeft + 1)
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