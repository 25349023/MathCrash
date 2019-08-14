-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require 'composer'

math.randomseed(os.time())
math.random()
math.random()

display.setStatusBar(display.HiddenStatusBar)

composer.setVariable("UIFont", native.newFont("SourceSansPro-Black.ttf", 24))
composer.setVariable("GameFont", native.newFont("PAPYRUS.TTF"))
composer.setVariable("cardNums", 17)

composer.gotoScene("menu", { effect='fade', time=400 })
