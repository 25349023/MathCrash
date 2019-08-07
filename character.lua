module(..., package.seeall)

local card = require 'card'

Character = { handCard=nil, currPoint=0, deck=nil, deckTop=1, cx=0, y=0, health=100,
              hide=false, CardGroup=nil, cardSheet=nil }

function Character:new(t)
    t = t or {}
    t['handCard'] = t['handCard'] or {}
    t['deck'] = t['deck'] or {}
    setmetatable(t, self)
    self.__index = self
    
    return t
end

function Character:init(evt)
    for i, v in ipairs(dofile(system.pathForFile('carddata.lua'))) do
        self.deck[i] = card.Card:new(v)
    end

    for i, c in ipairs(self.deck) do
        if self.hide then
            c.image = display.newImageRect(self.CardGroup, self.cardSheet, 16, 271, 431)
        else
            c.image = display.newImageRect(self.CardGroup, self.cardSheet, c.imgIndex, 271, 431)
        end
        if evt then
            c.image:addEventListener('tap', evt)
        end
        c.image.xScale = 0.3
        c.image.yScale = 0.3
        c.image.isVisible = false
    end
    self:_shuffleDeck()
end

function Character:_updatePoint(card)
    self.currPoint = card:calculate(self.currPoint)
end

function Character:drawCard()
    local cd = self:_drawCard()
    print('card : ' .. cd.op .. ' ' .. cd.data)
    self:_insertCardIntoHand(cd)
end

function Character:dealCards()
    local i = 1
    repeat
        local c = self:_drawCard()
        self.handCard[i] = c
        if self:checkInitialState() then
            c.image.x = self.cx - 200 + i * 100
            c.image.y = self.y
            c.image.isVisible = true
            print('card : ' .. c.op .. ' ' .. c.data)        
            i = i + 1
        else
            self.handCard[i] = nil
            print('discard: ' .. c.op .. ' ' .. c.data)
        end
    until #self.handCard == 3
    i = nil
    
    print('current grade: ' .. self:calculateGrade())
end

function Character:playCard(ind)
    print 'play one card'
    local cd = self.handCard[ind]
    transition.to(cd.image, { x=self.cx, alpha=0.5,
        xScale=0.2, yScale=0.2, time=500 })

    timer.performWithDelay(510, 
        function()
            self:_updatePoint(cd)
            transition.fadeOut(cd.image, { time=200,
                onComplete=function() 
                    self:_handleUsedCard(cd)
                    self.handCard[ind] = nil
                end })
        end)
end

function Character:handCardIndex(im)
    for i, c in ipairs(self.handCard) do
        if c.image == im then
            return i
        end
    end
    return nil
end


function Character:_drawCard()
    --[[
    Return one card from deck and check if need to shuffle.
    ]]
    local t 
    repeat
        t = self.deckTop
        self.deckTop = self.deckTop % #self.deck + 1
        if self.deckTop == #self.deck - 4 then
            self:_shuffleDeck(self.deckTop - 1)
        end
    until not self.deck[t].image.isVisible
     
    assert(not self.deck[t].image.isVisible, 'drawn card should be invisible.')
    return self.deck[t]
end

function Character:_insertCardIntoHand(cd)
    for i = 1, 3 do
        if self.handCard[i] == nil then
            self.handCard[i] = cd
            cd.image.x = self.cx - 200 + i * 100
            cd.image.y = self.y
            cd.image.isVisible = true
        end
    end
end

function Character:_handleUsedCard(cd)
    if self.hide then
        cd.image:removeSelf()
        cd.image = display.newImageRect(self.CardGroup, self.cardSheet, 16, 271, 431)
        cd.image.isVisible = false
        cd.image:scale(0.3, 0.3)
        return
    end
    
    cd.image.isVisible = false
    cd.image.xScale = 0.3
    cd.image.yScale = 0.3
    cd.image.alpha = 1
end


function Character:_shuffleDeck(num)
    --[[
    shuffle cards from 1 to num (default to sizeof cards)
    ]]
    num = num or #self.deck
    for i=0, 50 do
        a = math.random(num)
        b = math.random(num)
        self.deck[a], self.deck[b] = self.deck[b], self.deck[a]
    end
end

function Character:calculateGrade()
    local gsum = math.floor(self.currPoint / 2)
    for _, c in ipairs(self.handCard) do
        gsum = gsum + c.grading
    end
    return gsum
end

function Character:checkInitialState()
    local grade = self:calculateGrade()
    local spCnt = 0
    for _, c in ipairs(self.handCard) do
        if c.special then
            spCnt = spCnt + 1
        end
    end
    local gdPass = -1 <= grade and grade <= 6
    return gdPass and spCnt <= 1
end

