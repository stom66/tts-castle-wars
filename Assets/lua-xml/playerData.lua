
--[[
    Default data sets for players, as well as some basic player functions
--]]

function defaultPlayerData(player)
    local prefix = string.sub(player, 1, 3):lower()
    return {
        --object references
        castle_base_obj  = getObjectFromGUID(prefix.."001"),
        castle_tower_obj = getObjectFromGUID(prefix.."011"),
        wall_obj         = getObjectFromGUID(prefix.."002"),
        barracks_obj     = getObjectFromGUID(prefix.."003"),
        lodge_obj        = getObjectFromGUID(prefix.."004"),
        tower_obj        = getObjectFromGUID(prefix.."005"),
        gate_obj         = getObjectFromGUID(prefix.."006"),
        deck_pad_obj     = getObjectFromGUID(prefix.."007"),
        zone_obj         = getObjectFromGUID(prefix.."008"),
        deck_obj         = nil, --set by the checkDeck function

        --buff booleans
        buff_attack    = false,
        buff_build     = false,
        buff_defence   = false,
        buff_resources = false,

        --main stat counts
        builders       = 2,
        bricks         = 5,
        mages          = 2,
        crystals       = 5,
        soldiers       = 2,
        swords         = 5,
        castle         = 30,
        wall           = 10,

        --gameplay data
        turn           = false, --don't think this get used anymore
        deck_valid     = false, --used to check if the player has a valid deck and trigger the game start
        discards       = 0,     --counter for discards performed in a turn
        action_taken   = false, --simple flag to prevent playing multiple cards
        all_produce    = false, --flag to denote resource production buffs
    }
end

function playerCanAffordCard(player_color, cardId)
    --[[
        Check if the player can afford the card
        Does not check the [4]th value - wall - as this is only used by the Reverse card which works even if you dont have a wall
    --]]
    if data.debug then
        log("Checking if player "..player_color.." can afford card "..cardId)
        log("Player has: "..data[player_color].bricks.." bricks, "..data[player_color].crystals.." crystals, "..data[player_color].swords.." swords")
        log("Card costs: "..cards[cardId].cost[1].." bricks, ".. cards[cardId].cost[2].." crystals, ".. cards[cardId].cost[3].." swords")
    end

    if data[player_color].bricks < cards[cardId].cost[1]
    or data[player_color].crystals < cards[cardId].cost[2]
    or data[player_color].swords < cards[cardId].cost[3] then
        return false
    else
        return true
    end
end

function playerOpponent(player_color)
    --[[
        Simple function to get the opposite player of the one supplied
    --]]
    if string.lower(player_color) == "blue" then
        return "Red"
    else
        return "Blue"
    end
end