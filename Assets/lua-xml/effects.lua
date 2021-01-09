--[[

    Some functions for dealing with asset bundle trigger effects easily

--]]

function playTriggerByName(obj, name)
    --function to play a trigger effect by it's name rather than by it's index.
    --returns true if found, false if not found
    for i,v in ipairs(obj.AssetBundle.getTriggerEffects()) do
        if v.name==name then
            obj.AssetBundle.playTriggerEffect(v.index)
            return true
        end
    end
end

function triggerEffect(player_color, name)
    --function to play a trigger effect by it's name rather than by it's index.
    --also looks at target wall height and will play a trigger with a _castle or _wall
    --suffix depending on what's appropriate
    --returns true if found, false if not found
          name     = name:lower():gsub(" ", "_")
    local assBun   = data[player_color].effects_obj.AssetBundle
    local target   = playerOpponent(player_color)
    local triggers = assBun.getTriggerEffects()

    log("Attempting to play trigger effect: "..name)

    --loop through the list of possible triggers, searching for a name/name+suffix match
    for _,v in ipairs(triggers) do
        if v.name == name or
        (v.name == name.."_castle" and data[target].wall < 1) or
        (v.name == name.."_wall" and data[target].wall > 0) then
            assBun.playTriggerEffect(v.index)
            return true
        end
    end

    return false
end

function scaleEffects(player_color, scale)
    --scales the effects bundle

    local obj = data[player_color].effects_obj
    obj.setScale({scale, scale, scale})

    --sets it in the right position
    local position = obj.getPosition()
    if scale > 1 then
        position:setAt("x", 6)
    else
        position:setAt("x", 0)
    end

    if player_color=="Blue" then
        position:setAt("x", position.x * -1)
    end

    obj.setPosition(position)
end