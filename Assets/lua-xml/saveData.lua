function onSave()
    --[[
        Stock TTS event, triggered whenever the game saves
        Assembles the relevant data needed to continue a game and returns it as a string
    --]]
    local save     = {
        game_state = data.game_state,
        turn_count = data.turn_count,
        Blue       = saveData_readPlayerData("Blue"),
        Red        = saveData_readPlayerData("Red"),
    }
    local json = JSON.encode(save)

    if data.debug then
        --log("Game is saving, save_data:")
        --log(json)
    end

    return json
end

function saveData_readPlayerData(player_color)
    --[[
        Reads through the data stored for each player and converts obj references to GUIDs
    --]]

    local t = {}
    for key,value in pairs(data[player_color]) do
        if type(value)=="userdata" then
            t[key] = value.getGUID()
        else
            t[key] = value
        end
    end
    return t
end


function loadSave(saved_data)
    --[[
        Triggerd by the Stock TTS function onLoad() if save_data is present
        Checks it for validity and recreates object references from GUIDs
    --]]

    local json = JSON.decode(saved_data)

    if data.debug then
        log("loadSave triggered with data:")
        log(json)
    end

    if json then
        if json.game_state then data.game_state = json.game_state end
        if json.turn_count then data.turn_count = tonumber(json.turn_count) end

        if json.Blue then data.Blue = saveData_parsePlayerData(json.Blue) end
        if json.Red then data.Red   = saveData_parsePlayerData(json.Red) end

    end

    data.loading = false
end

function saveData_parsePlayerData(data)
    --[[
        Reads a table of saved player data and converts string to objects references
    --]]
    local t = {}
    for key,value in pairs(data) do
        if type(value) == "string" then
            t[key] = getObjectFromGUID(value)
        else
            t[key] = value
        end
    end
    return t
end