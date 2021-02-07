
function outlinePlayerHands()
    local vlines = {}

    for k,v in ipairs(Hands.getHands()) do
        local rot = v.getRotation().y
        local pos = v.getPosition():setAt("y", 0.6)
        local color = Color.fromString(v.getValue())
        local scale = v.getScale():scale(Vector(0.7, 1, 0.8))
        local scale3 = scale:copy():scale(Vector(1.025, 1, 1.175))


        table.insert(vlines, vline_capsule(pos, rot, scale, color, 0.25))
        table.insert(vlines, vline_capsule(pos, rot, scale3, color, 0.1))
    end

    Global.setVectorLines(vlines)
end

function vline_capsule(pos, rot_y, scale, color, thickness)
    local steps    = 20
    local angle    = 180/steps
    local t        = {
        points     = {},
        color      = color or {1,1,1},
        thickness  = thickness or 0.5,
        rotation   = {0,0,0},
    }
    local x, z     = scale.x, scale.z
    local offset_z = Vector(0, 0, z/2):rotateOver("y", rot_y)
    local offset_x = Vector(x/2, 0, 0):rotateOver("y", rot_y)

    for i=0,steps do
        table.insert(t.points, offset_z:copy():rotateOver("y", i*angle):add(offset_x):add(pos))
    end
    offset_x:inverse()
    offset_z:inverse()
    for i=0,steps do
        table.insert(t.points, offset_z:copy():rotateOver("y", i*angle):add(offset_x):add(pos))
    end

    table.insert(t.points, t.points[1])

    return t
end