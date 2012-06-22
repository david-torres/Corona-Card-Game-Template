require 'stack'
require 'game_config'
require 'game'
json = require 'json'
widget = require 'widget'

display.setStatusBar(display.HiddenStatusBar)

-- init game
Game:new_game()