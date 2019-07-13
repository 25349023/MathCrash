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

local cards = {}
local deckTop = 1
for i, v in ipairs(dofile(system.pathForFile('carddata.lua'))) do
    cards[i] = card.Card:new(v)
end

local player
local opponent


local function clickToFront(event)
    event.target:toFront()
    return true
end


local function shuffleCards(cd, num)
    --[[
    shuffle cards from 1 to num (default to sizeof cards)
    ]]
    num = num or #cd
    for i=0, 50 do
        a = math.random(num)
        b = math.random(num)
        cd[a], cd[b] = cd[b], cd[a]
    end
    
end


local function calculateGrade(handCard, initPt)
    local gsum = math.floor(initPt / 2)
    for _, c in ipairs(handCard) do
        gsum = gsum + c.grading
    end
    return gsum
end


local function checkInitialState(handCard, initPt)
    local grade = calculateGrade(handCard, initPt)
    local spCnt = 0
    for _, c in ipairs(handCard) do
        if c.special then
            spCnt = spCnt + 1
        end
    end
    local gdPass = -1 <= grade and grade <= 6
    return gdPass and spCnt <= 1
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
    
    --[=[
    for i=0,4 do
        for j=1,3 do
            k = i * 3 + j
            cardImage[k] = display.newImageRect(CardGroup, cardSheet, k, 271, 431)
            cardImage[k].xScale = 0.3
            cardImage[k].yScale = 0.3
            cardImage[k].isVisible = false
            --[[
            cards[k].x = centerX - 200 + j * 100
            cards[k].y = centerY - 250 + i * 120
            --]]
            cardImage[k]:addEventListener('tap', clickToFront)
        end
    end
    ]=]
    
    player = character.Character:new{ currPoint=math.random(10) }
    
    for i, c in ipairs(cards) do
        c.image = display.newImageRect(CardGroup, cardSheet, cards[i].imgIndex, 271, 431)
        c.image.xScale = 0.3
        c.image.yScale = 0.3
        c.image.isVisible = false
        c.image:addEventListener('tap', clickToFront)
    end
        
    shuffleCards(cards)
    for i=1,3 do
        cards[i].image.x = centerX - 200 + i * 100
        cards[i].image.y = centerY + 200
        cards[i].image.isVisible = true
        player.handCard[#player.handCard+1] = cards[i]
        print('card : ' .. cards[i].op .. ' ' .. cards[i].data)
    end
    
    
    print('current grade: ' .. calculateGrade(player.handCard, player.currPoint))
    
    UI['playerPoint'] = display.newText{ parent=UIGroup, text=player.currPoint, x=centerX, y=centerY,
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