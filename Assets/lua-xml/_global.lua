function onLoad(saved_data)
    data = {
        deal_interval        = 0.15,      --delay between cards being dealt
        delay_before_start   = 3,         --delay after both plaayers lock-in before round starts
        game_state           = "pregame", --"pregame", "countdown", "active", "stopped", "finished"
        max_card_duplicates  = 5,         --max number of any one card that can be in a valid deck
        max_cards_in_deck    = 5*56,      --max_card_duplicates * card count
        max_cards_in_hand    = 8,         --used for dealing replacement cards on turn_end
        max_discard_per_turn = 3,         --self explanatory
        turn_count           = 0,         --primarily used to determine if resources should be increased
        loading              = false,     --loading flag to let game know when to continue with setup
        xml_visibility       = {
            info             = {"Red", "Blue", "Black", "White"},
            win              = {"None"},
            lose             = {"None"},
        }
    }

    cards     = card_getDataTable() --info on cards, functions, costs, etc
    decks     = deck_getDataTable() --info on decks: names and card counts
    lang      = lang_getStrings()   --language strings
    zoneWaits = {}                  --empty table for ScriptingZone Wait.conditions

    players = {"Blue", "Red"}       --table of players for easy looping

    for _,player in ipairs(players) do
        data[player] = player_defaultData(player)
    end

    --check to see if save_data was provided
    --if saved_data then
    --    data.loading = true
    --    loadSave(saved_data)
    --end

    --wait for save_data to load and parse before triggering the XML update
    Wait.condition(
        function()
            for _,player_color in ipairs(players) do
                --update the XML with the various stats and buffs
                xml_update(player_color)

                --draw Buttons on player's deck pads
                deckpad_drawButtons(player_color)

                --during debug, automatically spawn a deck for each player 1 second after loading the game
                if data.debug and not data[player_color].deck_obj then
                    deck_spawnDeck(3, player_color)
                end
            end
        end,
        function() return not data.loading end
    )

    --check to see if data.debug should be automatically enabled
    checkForDebug()
end


--[[
    Add scripting key shortcuts
--]]
function onScriptingButtonDown(index, player_color)
    if player_isValid(player_color) then
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
--require("tts-castle-wars/Assets/lua-xml/saveData")

require("tts-castle-wars/Assets/lua-xml/debug")

require("tts-castle-wars/Assets/lua-xml/lang")
require("tts-castle-wars/Assets/lua-xml/broadcast")

require("tts-castle-wars/Assets/lua-xml/playerActions")
require("tts-castle-wars/Assets/lua-xml/playerContextActions")
require("tts-castle-wars/Assets/lua-xml/playerData")
require("tts-castle-wars/Assets/lua-xml/playerManagement")

require("tts-castle-wars/Assets/lua-xml/cardActions")
require("tts-castle-wars/Assets/lua-xml/cardData")

require("tts-castle-wars/Assets/lua-xml/deckActions")
require("tts-castle-wars/Assets/lua-xml/deckData")
require("tts-castle-wars/Assets/lua-xml/deckPad")

require("tts-castle-wars/Assets/lua-xml/effects")

require("tts-castle-wars/Assets/lua-xml/gameActions")
require("tts-castle-wars/Assets/lua-xml/resources")
require("tts-castle-wars/Assets/lua-xml/turnActions")

require("tts-castle-wars/Assets/lua-xml/xmlFunctions")
require("tts-castle-wars/Assets/lua-xml/zoneActions")

--utility stuff
require("tts-castle-wars/Assets/lua-xml/obj")
require("tts-castle-wars/Assets/lua-xml/math")
require("tts-castle-wars/Assets/lua-xml/table")