
--[[
    Default data sets for players, as well as some basic player functions
--]]

function player_defaultData(player_color)
    local data = {}
    table.merge(data, player_objReferences(player_color))
    table.merge(data, player_defaultStats())

    return data
end

function player_defaultStats()
    --[[
        Returns the defaults stats for a player, used when starting or restarting a game
    --]]
    return {
        --main stat counts
        builders = 2,
        bricks   = 5,
        mages    = 2,
        crystals = 5,
        soldiers = 2,
        swords   = 5,
        castle   = 30,
        wall     = 10,

        --buff booleans
        buff = {
            attack    = false,
            build     = false,
            defence   = false,
            resources = false,
        },

        --gameplay data
        deck_valid     = false, --used to check if the player has a valid deck and trigger the game start
        action_taken   = false, --simple flag to prevent playing multiple cards
        all_produce    = false, --flag to denote resource production buffs

        --discard data
        discard_objs   = {}, --table of cards potentially being discarded by sabotage
        discards       = 0,  --counter for discards performed in a turn
    }
end

function player_objReferences(player_color)
    --[[
        Gets and returns references to the player's objects
    --]]

    --workout the asset prefix based on the player color
    local prefix = string.sub(player_color, 1, 3):lower()

    local t = {
        castle_base_obj    = getObjectFromGUID(prefix.."001"),
        wall_obj           = getObjectFromGUID(prefix.."002"),
        barracks_obj       = getObjectFromGUID(prefix.."003"),
        lodge_obj          = getObjectFromGUID(prefix.."004"),
        tower_obj          = getObjectFromGUID(prefix.."005"),
        gate_obj           = getObjectFromGUID(prefix.."006"),
        deck_pad_obj       = getObjectFromGUID(prefix.."007"),
        zone_obj           = getObjectFromGUID(prefix.."008"),
        play_pad_obj       = getObjectFromGUID(prefix.."009"),
        castle_tower_obj   = getObjectFromGUID(prefix.."010"),
        flag1_obj          = getObjectFromGUID(prefix.."011"),
        flag2_obj          = getObjectFromGUID(prefix.."012"),
        effects_obj        = getObjectFromGUID(prefix.."013"),
        effects_wall_obj   = getObjectFromGUID(prefix.."014"),
        effects_castle_obj = getObjectFromGUID(prefix.."015"),
        handzone_obj       = getObjectFromGUID(prefix.."016")
    }

    --check for an existing deck_obj, in case we're resetting the player data after a completed game
    if data[player] and data[player].deck_obj then
        t.deck_obj = data[player].deck_obj
    end

    return t
end

function player_canAffordCard(player_color, cardId)
    --[[
        Check if the player can afford the card
        Does not check the [4]th value - wall - as this is only used by the Reverse card which works even if you dont have a wall
    --]]
    if data.debug then
        --log("Checking if player "..player_color.." can afford card "..cardId)
        --log("Player has: "..data[player_color].bricks.." bricks, "..data[player_color].crystals.." crystals, "..data[player_color].swords.." swords")
        --log("Card costs: "..cards[cardId].cost[1].." bricks, ".. cards[cardId].cost[2].." crystals, ".. cards[cardId].cost[3].." swords")
        --log("Checking if player "..player_color.." can afford card "..cardId)
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