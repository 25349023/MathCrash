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
    numFrames=15
}
local cardSheet = graphics.newImageSheet("images/cards/cards.png", cardsOption)

local CardGroup
local cardImage = {}
setmetatable(cardImage, weakMeta)

local player
local opponent


local function clickToFront(event)
    event.target:toFront()
    return true
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
    
    --[[
    cards[k].x = centerX - 200 + j * 100
    cards[k].y = centerY - 250 + i * 120
    --]]
    
    player = character.Character:new{ currPoint=math.random(10) }
    player:init(CardGroup, cardSheet)
    player:shuffleDeck()
    
    -- draw init card
    print('player init point: ' .. player.currPoint)
    local i = 1
    repeat
        local c = player:drawCard()
        player.handCard[i] = c
        if not c.image.isVisible and player:checkInitialState() then
            c.image.x = centerX - 200 + i * 100
            c.image.y = centerY + 200
            c.image.isVisible = true
            print('card : ' .. c.op .. ' ' .. c.data)        
            i = i + 1
        else
            player.handCard[i] = nil
            print('discard: ' .. c.op .. ' ' .. c.data)
        end
    until #player.handCard == 3
    i = nil
    
    print('current grade: ' .. player:calculateGrade())
    
    UI['playerPoint'] = display.newText{ parent=UIGroup, text=player.currPoint, x=centerX, y=centerY+50,
        font=composer.getVariable("GameFont"), fontSize=72 }
    UI['playerPoint']:setFillColor(0.2, 0.2, 0.4)
    
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