--[[
    This file contains the functions used by the XML UI Deck Builder
--]]

function xml_db_sliderChange(player, value, id)
    local cardID = id:gsub("slider_", "")
          value  = tonumber(value)
    if data.debug then
        log("xml_db_sliderChange(): Updating CardID "..cardID.." to value "..value)
    end
    UI.setAttribute("qty_"..cardID, "text", value)
end

function xml_db_allMax(player, value, id)
    for cardID, _ in pairs(cards) do
        UI.setAttribute("qty_"..cardID, "text", data.max_card_duplicates)
        UI.setValue("slider_"..cardID, data.max_card_duplicates)
    end
end

function xml_db_loadDeck(player, value, id)
    local deck_name = UI.getValue("xml_db_dropdown_loadDeck")
    local index

    if data.debug then log("xml_db_loadDeck(): Looking for deck_name: "..deck_name) end

    --find the index of the deck to be spawned
    for i,name in ipairs(decks.names) do
        if name==deck_name then
            index = i
            if data.debug then 
                log("xml_db_loadDeck(): found deck_name "..deck_name.." at index "..index) 
            end
            break
        end
    end

    for cardID, value in pairs(decks.cards) do
        UI.setAttribute("qty_"..cardID, "text", value)
        UI.setValue("slider_"..cardID, value)
    end
end

