module(..., package.seeall)

Character = { handCard=nil, currPoint=0 }

function Character:new(t)
    t = t or {}
    t['handCard'] = t['handCard'] or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Character:updatePoint(card)
    self.currPoint = card:calculate(self.currPoint)
end
