module(..., package.seeall)

Card = { op='', data=0, grading=0, special=false, imgIndex=0, image=nil }

function Card:new(t)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    self.__mode = 'v'
    return t
end

function Card:calculate(x)
    if self.op == '+' then
        return x + self.data
    elseif self.op == '-' then
        return x - self.data
    elseif self.op == '*' then
        return x * self.data
    elseif self.op == '/' then
        return math.ceil(x / self.data)
    elseif self.op == '^' then
        return x ^ self.data
    elseif self.op == '+-' then
        return -x
    end
    return x
end
