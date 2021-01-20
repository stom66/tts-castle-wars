function lang_getStrings()
    return {
        cant_afford_card         = "You cannot afford to use that card!",
        cant_play_after_discard  = "You can't play a card in the same turn as discarding cards",
        cant_play_multiple_cards = "You can only play one card at a time, please select a single card",
        cant_play_non_card       = "You can't play an object that isn't a card",
        card_played              = function(s1, s2) return s1.." played card "..s2 end,
        card_unknown             = function(id) return "Unknown card played! ID "..id end,
        card_not_in_hand         = "That card does not belong to you!",
        deck_not_in_zone         = "You must place a deck in the zone to check",
        deck_not_locked          = "You must have a valid locked deck to play a card",
        deck_not_locked2         = "You must have a valid locked deck to discard a card",
        deck_not_yours           = function(c) return "Only player "..c.." can control their deck!" end,
        deck_too_large           = "Deck is too large! Max size is "..data.max_cards_in_deck,
        deck_valid               = "Your deck is ready and loaded!",
        discard_choose_card      = "Choose one of your opponents cards to discard",
        discard_wait_for_player  = "Oh no! Your deck is being sabotaged! Wait for it...",
        game_lost                = "Oh no! You have been defeated!",
        game_start_cancelled     = "Game start cancelled",
        game_started             = "The game has begun!",
        game_starts_in           = function(i) return "Game is starting in "..i.."..." end,
        game_stopped             = "The game has been stopped.",
        game_won                 = "Congratulations! You have won the game!",
        max_discards_reached     = "You can only discard "..data.max_discard_per_turn.." cards per turn",
        not_your_turn            = "It is not your turn! Wait for the other player to finish their turn",
        player_discarded_cards   = function(p, i) return Player[p].steam_name.." discarded "..i.." cards" end,
        too_many_duplicate_cards = function(s) return "You have too many '"..s.."' cards. The maximum is "..data.max_card_duplicates end,
    }
end