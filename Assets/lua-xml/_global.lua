function onLoad()
    data = {
        deal_interval        = 0.15,      --delay between cards being dealt
        delay_before_start   = 1,         --delay after both plaayers lock-in before round starts
        game_state           = "pregame", --"pregame", "countdown", "active", "stopped", "finished"
        max_card_duplicates  = 5,         --max number of any one card that can be in a valid deck
        max_cards_in_deck    = 5*56,      --max_card_duplicates * card count
        max_cards_in_hand    = 8,         --used for dealing replacement cards on turn_end
        max_discard_per_turn = 3,         --self explanatory
        turn_count           = 0,         --primarily used to determine if resources should be increased
        debug                = true,      --controls visibility of casts and toggles logging
    }
    data.Blue = defaultPlayerData("Blue")
    data.Red  = defaultPlayerData("Red")

    zoneWaits = {} --empty table, used for scripting zone wait conditions

    cards = getCardData() --info on cards, functions, costs, etc

    lang = {
        too_many_duplicate_cards = function(s) return "You have too many '"..s.."' cards. The maximum is "..data.max_card_duplicates end,
        deck_too_large           = "Deck is too large! Max size is "..data.max_cards_in_deck,
        deck_valid               = "Your deck is ready and loaded!",
        not_your_turn            = "It is not your turn! Wait for the other player to finish their turn",
        cant_afford_card         = "You cannot afford to use that card!",
        cant_play_multiple_cards = "You can only play one card at a time, please select a single card",
        cant_play_non_card       = "You can't play an object that isn't a card",
        cant_play_after_discard  = "You can't play a card in the same turn as discarding cards",
        max_discards_reached     = "You can only discard "..data.max_discard_per_turn.." cards per turn",
        card_not_in_hand         = "That card does not belong to you!",
        game_starts_in           = function(i) return "Game is starting in "..i.."..." end,
        game_start_cancelled     = "Game start cancelled",
        game_started             = "The game has begun!",
        game_stopped             = "The game has been stopped.",
        game_won                 = "Congratulations! You have won the game!",
        game_lost                = "Oh no! You have been defeated!",
    }

    xml_update("Blue")
    xml_update("Red")
end

--[[
    Add card context menu controls
--]]
function onObjectSpawn(obj)
    --[[
        Adds suitable context menu items to Cards when they are spawned. Ignores non-card objects.
    --]]

    if obj.tag~="Card" then return false end
    obj.addContextMenuItem("Play Card", trigger_playCard)
    obj.addContextMenuItem("Discard Card", trigger_discardCard)
end

--[[
    Add scripting key shortcuts
--]]
function onScriptingButtonDown(index, player_color)
    if (player_color == "Blue" or player_color == "Red") then
        if index == 1 then
            trigger_playCard(player_color)
        elseif index == 10 then
            trigger_discardCard(player_color)
        end
    end
end

--[[
    Requires the main game files
--]]
require("CastleWars/Assets/lua-xml/playerActions")
require("CastleWars/Assets/lua-xml/playerData")

require("CastleWars/Assets/lua-xml/cardActions")
require("CastleWars/Assets/lua-xml/cardData")
require("CastleWars/Assets/lua-xml/deckActions")

require("CastleWars/Assets/lua-xml/gameActions")
require("CastleWars/Assets/lua-xml/resources")
require("CastleWars/Assets/lua-xml/turnActions")

require("CastleWars/Assets/lua-xml/xmlFunctions")
require("CastleWars/Assets/lua-xml/zoneActions")