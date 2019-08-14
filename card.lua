module(..., package.seeall)

Card = { op='', data=0, grading=0, special=false, imgIndex=0, image=nil }


local function sign1(x)
    -- suffix "1" because this function will return 1 when x == 0
    return x >= 0 and 1 or -1
end

local function round(num) 
    if num >= 0 then
        return math.floor(num+.5) 
    else
        return math.ceil(num-.5) 
    end
end


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
    elseif self.op == 'cr' then
        local sig = sign1(x)
        res = sig * round(math.abs(x) ^ (1/3))
    end
    if res == 0 then
        return 0
    elseif res >= 65536 then
        return 65536
    elseif res <= -65536 then
        return -65536
    end

    return res
end
