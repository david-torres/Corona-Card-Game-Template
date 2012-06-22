GameConfig = {
    deck = 
    {
        data = 'assets/deck.json',
        shuffles = 5,
    },

    hand = {
        size = 5
    },
    
    card = {
        back = 'assets/card_back.png',
        height = 150,
        width = 100,
        face = {
            heart = 'assets/heart.png',
            diamond = 'assets/diamond.png',
            club = 'assets/club.png',
            spade = 'assets/spade.png',
        },
        states = {
            faceup = 1,
            facedown = 2
        }
    },

    background = 'assets/wood_table.png',

    sounds = {
        card_flip = 'assets/card_flip.wav',
        shuffle = 'assets/shuffle.wav',
    },

    start_pos = {
        p1 = {
            x = 0,
            y = display.contentHeight - 150 * 0.5,
        },
        p2 = {
            x = 0,
            y = 150 * 0.5,
        },
    },

    _W = display.contentWidth * 0.5,
    _H = display.contentHeight * 0.5,
}
