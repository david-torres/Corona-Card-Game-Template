-- 
-- Create a new Card object
-- 
Card = {}
function Card:new (card_data)
    local self = { 
        _id = nil
    }

    -- add the card data to self
    for k, v in pairs(card_data) do self[k] = v end

    -- generate a uniq id, makes Stack:pick easier
    local id = function()
        if self._id == nil then 
            local r1 = math.random(1, 9999)
            local r2 = math.random(1, 9999)
            local r3 = math.random(1, 9999)
            local r4 = math.random(1, 9999)

            self._id = r1 .. '-' .. r2 .. '-' .. r3 .. '-' .. r4
        end
        return self._id
    end

    -- fetch attributes of this card by key
    local get = function(n)
        return self[n]
    end

    return {
        id = id,
        get = get
    }
end

-- 
-- Create a new Stack object
-- 
Stack = {}
function Stack:new (card_data)
    -- list of all the cards in this stack
    local self = {
        cards = {}
    }

    -- shuffle the stack N times
    local shuffle = function(n)
        local rand = math.random 
        local j
        
        for i = 0, n do
            for i = #self.cards, 2, -1 do
                j = rand(i)
                self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
            end
        end
    end

    -- deal the top card from this stack
    local deal = function()
        return table.remove(self.cards, 1)
    end

    -- draw N cards from the top of this stack
    local draw = function(n)
        local drawn_cards = {}
        for i = 1, n do 
            local card = table.remove(self.cards, 1)
            table.insert(drawn_cards, card)
        end
        return drawn_cards
    end

    -- remove a card from this stack by id
    local pick = function(id)
        for i, card in ipairs(self.cards) do 
            if card.id() == id then
                return table.remove(self.cards[i])
            end
        end
    end

    -- add a card to the end of this stack
    local add = function(card)
        table.insert(self.cards, #self.cards + 1, card)
    end

    -- combine this stack with another
    local combine = function(stack)
        for i, card in ipairs(stack) do
            table.insert(self.cards, #self.cards + 1, card)
        end
        stack = nil
    end

    -- how many cards are in this stack
    local count = function()
        return #self.cards
    end

    -- cards getter
    local cards = function()
        return self.cards
    end

    return {
        cards = cards,
        shuffle = shuffle,
        deal = deal,
        draw = draw,
        pick = pick,
        add = add,
        combine = combine,
        count = count,
    }
end

--
-- Initialize stack contents from a file
--
function Stack:load (path)
    local file_handle, reason = io.open(path, 'r')

    if file_handle then
        -- read all contents of file into a string
        local contents = file_handle:read('*a')
        local deck_data = json.decode(contents)
        local deck = Stack:new()
        for i, card_data in ipairs(deck_data) do 
            card_object = Card:new(card_data)
            deck.add(card_object)
        end

        return deck
    else
        native.showAlert('Debug', 'Reading deck file failed: ' .. reason)
    end
end
