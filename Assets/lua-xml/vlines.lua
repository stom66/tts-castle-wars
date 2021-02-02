
function outlinePlayerHands()
    local vlines = {}
    for _,v in ipairs(getSeatedPlayers()) do
        local hand              = Player[v].getHandTransform()
        local rot_y             = hand.rotation.y
        local width_x, height_z = hand.scale.x, hand.scale.z
        local pos               = hand.position:sub(Vector(0,0, 0))

        table.insert(vlines, vline_capsule(pos, rot_y, width_x, height_z, Color.fromString(v), 0.4))
        --table.insert(vlines, vline_capsule(pos, rot_y, width_x-0.25, height_z-0.25, Color.fromString(v), 0.25))
    end
    Global.setVectorLines(vlines)
end

function vline_capsule(pos, rot_y, x, z, color, thickness)
    local steps = 20
    local angle = 180/steps
    local t = {
        points    = {},
        color     = color or {1,1,1},
        thickness = thickness or 0.5,
        rotation  = {0,0,0},
    }
    for i=0,steps do
        table.insert(t.points, pos:copy():add(Vector(0, 0, z/2):rotateOver("y", i*angle):add(Vector(x/2, 0, 0))))
    end
    for i=0,steps do
        table.insert(t.points, pos:copy():add(Vector(0, 0, 0-z/2):rotateOver("y", i*angle):add(Vector(0-(x/2), 0, 0))))
    end
    
    table.insert(t.points, pos:add(Vector(x/2, 0, z/2)))

    return t
end