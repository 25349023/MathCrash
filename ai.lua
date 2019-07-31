module(..., package.seeall)

AI = { role=nil }

function AI:new(t)
    t = t or {}
    t['role'] = t['role'] or {}
    local m = getmetatable(t)
    setmetatable(t, self)
    self.__index = self
    
    return t
end

function AI:chooseCard()
    error('this is a abstract function.', 2)
end

RandomAI = AI:new()

function RandomAI:chooseCard()
    return math.random(1000) % 3 + 1
end

