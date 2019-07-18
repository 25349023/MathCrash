module(..., package.seeall)

local card = require 'card'

Character = { handCard=nil, currPoint=0, deck=nil, deckTop=1 }

function Character:new(t)
    t = t or {}
    t['handCard'] = t['handCard'] or {}
    t['deck'] = t['deck'] or {}
    setmetatable(t, self)
    self.__index = self
    
    return t
end

function Character:init(CardGroup, cardSheet, hide)
    hide = hide or false
    for i, v in ipairs(dofile(system.pathForFile('carddata.lua'))) do
        self.deck[i] = card.Card:new(v)
    end

    for i, c in ipairs(self.deck) do
        if hide then
            c.image = display.newImageRect(CardGroup, cardSheet, 16, 271, 431)
        else
            c.image = display.newImageRect(CardGroup, cardSheet, c.imgIndex, 271, 431)
        end
        c.image.xScale = 0.3
        c.image.yScale = 0.3
        c.image.isVisible = false
    end
end

function Character:updatePoint(card)
    self.currPoint = card:calculate(self.currPoint)
end

function Character:drawCard()
    --[[
    Return one card from deck and check if need to shuffle.
    ]]
    local t = self.deckTop
    self.deckTop = self.deckTop % #self.deck + 1
    if self.deckTop == #self.deck - 4 then
        self:shuffleDeck(self.deckTop - 1)
    end
    
    return self.deck[t]
end

function Character:dealCards(cx, y)
    local i = 1
    repeat
        local c = self:drawCard()
        self.handCard[i] = c
        if not c.image.isVisible and self:checkInitialState() then
            c.image.x = cx - 200 + i * 100
            c.image.y = y
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

function Character:shuffleDeck(num)
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

