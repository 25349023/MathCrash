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
    local res = x
    if self.op == '+' then
        res = x + self.data
    elseif self.op == '-' then
        res = x - self.data
    elseif self.op == '*' then
        res = x * self.data
    elseif self.op == '/' then
        res = math.ceil(x / self.data)
    elseif self.op == '^' then
        res = x ^ self.data
    elseif self.op == '+-' then
        res = -x
    end
    if res == 0 then
        return 0
    end
    return res
end
