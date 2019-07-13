require "card"

cd = {}

for i, v in ipairs(dofile 'carddata.lua') do
    print(i .. '-th card')
    cd[i] = card.Card:new(v)
    print(cd[i].op, cd[i].data)
    print(cd[i]:calculate(3))
end
