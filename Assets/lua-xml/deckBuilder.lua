--[[
    This file contains the functions used by the XML UI Deck Builder
--]]

function xml_toggle_deckBuilder(player, value, id)
    --[[
        Called by either the deckpad_obj Lua button or
        by the close button in the Deck Builder XML UI
    --]]
    local pc = player.color:lower()
    xml_toggleElement(pc.."_deckBuilder", pc)
end

function xml_db_sliderChange(player, value, id)
    --[[
        Called whenever a player adjusts a slider in the DeckBuilder XML UI.
        Receives the value and applies it to the text element above the slider
    --]]
    local card_qty_element = id:gsub("slider", "qty")
          value  = tonumber(value)
    UI.setAttribute(card_qty_element, "text", value)
    UI.setAttribute(id, "value", value)

    if data.debug then
        log("xml_db_sliderChange(): Updating "..card_qty_element.." to value "..value)
    end
end

function xml_db_loadDeck_dropdown(player, value, id)
    --[[
        Triggered by the dropdown element in the DeckBuilder UI being changed
        Converts the name of the deck into an index of the deck in global decks table
        to be used by the loadDeck function
        Because we can't read the value of a dropdown later we have to store it for use
        by the load_deck function
    --]]
    local index = 1 --a default value, needed in case the user hasnt triggered onChange

    --loop through the stored deck names to find the index
    for i,name in ipairs(decks.names) do
        if value == name then
            index = i
            break
        end
    end

    if data.debug then
        log("xml_db_loadDeck(): chose deck "..value.." with index "..index)
    end

    local player_color = player.color:lower()

    for cardID, value in pairs(decks.cards) do
        UI.setAttribute(player_color.."_qty_"..cardID, "text", value[index])
        UI.setAttribute(player_color.."_slider_"..cardID, "value", value[index])
    end
end

function xml_db_spawnDeck(player, value, id)
    --[[
        Triggered when the player click "Spawn Deck" in the deck builder UI
        Creates a local table of card_counts by cycling through each slider element
        Triggers deck_spawnDeck() with index 0 and a table of card counts
    --]]
    local card_count   = {}
    local total_cards  = 0
    local player_color = player.color:lower()
    for cardID, _ in pairs(decks.cards) do
        local count        = tonumber(UI.getAttribute(player_color.."_slider_"..cardID, "value"))
        total_cards        = total_cards + count
        card_count[cardID] = count
    end

    if total_cards < data.min_cards_in_deck then
        bToColor(lang.deck_too_small, player.color)
        return false
    end

    if data.debug then
        log("xml_db_spawnDeck(): "..player_color..", card_counts:")
        log(card_count)
    end

    deck_spawnDeck(0, player.color, card_count)

    xml_toggle_deckBuilder(player)
end

