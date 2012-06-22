--
-- Game controller
--
Game = {
    deck = {
        stack = nil
    },
    bg = {
        image = nil
    },
    hand = {
        stack = Stack:new(),
        rigs = {}
    },
    sounds = {
        card_flip = audio.loadSound(GameConfig.sounds.card_flip),
        shuffle = audio.loadSound(GameConfig.sounds.shuffle),
    }
}

--
-- initializes the game state and playable area
--
function Game:new_game()
    Game:init_background()

    Game:init_deck()
    Game:deal()

    Game:listeners()

end

--
-- Draws the background texture
--
function Game:init_background()
    Game.bg.image = display.newImage(GameConfig.background, 0, 0, true)
    Game.bg.image.x = GameConfig._W
    Game.bg.image.y = GameConfig._H
end

--
-- load deck from json
--
function Game:init_deck()  
    local path = system.pathForFile(GameConfig.deck.data)
    Game.deck.stack = Stack:load(path)
end

--
-- Shuffles the deck and deals the initial stacks
--
function Game:deal()
    Game:sfx('shuffle')
    Game.deck.stack.shuffle(GameConfig.deck.shuffles)
    for hand_index = 1, GameConfig.hand.size do
        Game.hand.stack.add(Game.deck.stack.deal())
    end

    local cards = Game.hand.stack.cards()
    for card_index = 1, #cards do
        local x = card_index * (GameConfig.card.width + 50)
        local card_rig = Game:card(cards[card_index], x, GameConfig._W / 2, GameConfig.card.states.facedown)
        table.insert(Game.hand.rigs, card_index, card_rig)
    end
end

--
-- Plays sound effects
--
function Game:sfx(name)
    local channel = audio.play(Game.sounds[name])
end

--
-- Draws a blank card back
--
function Game:blank(x, y)
    return display.newImage(GameConfig.card.back, x, y)
end

--
-- Draws a card
--
function Game:card(card, x, y, state)
    local suit = card.get('suit')
    local value = card.get('value')

    local card_rig = display.newGroup()
    card_rig.card = card

    if state == GameConfig.card.states.faceup then
        card_rig.state = state

        local value_text = display.newText(value, 0, 0, 'Arial', 32)
        value_text:setTextColor(0, 0, 0, 255)

        if suit == 'Heart' then
            card_rig:insert(display.newImage(GameConfig.card.face.heart))
            card_rig:insert(value_text)
        elseif suit == 'Diamond' then
            card_rig:insert(display.newImage(GameConfig.card.face.diamond))
            card_rig:insert(value_text)
        elseif suit == 'Club' then
            card_rig:insert(display.newImage(GameConfig.card.face.club))
            card_rig:insert(value_text)
        elseif suit == 'Spade' then
            card_rig:insert(display.newImage(GameConfig.card.face.spade))
            card_rig:insert(value_text)
        end
    else
        card_rig.state = state
        card_rig:insert(display.newImage(GameConfig.card.back))
    end

    card_rig.x = x
    card_rig.y = y

    card_rig:addEventListener('tap', Game:flip_card(e))

    return card_rig
end

--
-- Event handler for flipping a card
--
function Game:flip_card(e)
    return function(e)
        Game:sfx('card_flip')
        if e.target.state == GameConfig.card.states.faceup then
            Game:card(e.target.card, e.target.x, e.target.y, GameConfig.card.states.facedown)
        else
            Game:card(e.target.card, e.target.x, e.target.y, GameConfig.card.states.faceup)
        end
        display.remove(e.target)
    end
end

--
-- Event listeners
--
function Game:listeners()

end
