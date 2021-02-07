function tablet_showWiki(player, id, value)
    xml_hideInfo(player)
    tablet_goToPage("wiki", player.color)
end
function tablet_showTutorial(player, id, value)
    xml_hideInfo(player)
    tablet_goToPage("tutorial", player.color)
end
function tablet_showWorkshop(player, id, value)
    xml_hideInfo(player)
    tablet_goToPage("workshop", player.color)
end


function tablet_spawnTablet(page, player_color)
    if data.debug then
        log("tablet_spawnTablet("..page..")")
    end

    --if a tablet exists then direct it to the page
    if data.tablet_obj then
        tablet_goToPage(page)
        return false
    end

    local tablet = spawnObject({
        type                = "Tablet",
        position            = Vector(0, 3, 46),
        rotation            = Vector(45, 0, 0),
        callback_function   = function(obj)
            obj.setLock(true)
            data.tablet_obj = obj
            tablet_goToPage(page, player_color)
        end
    })
end

function tablet_goToPage(page, player_color)
    if data.debug then
        log("tablet_goToPage("..page..")")
    end

    local pages  = {
        wiki     = "https://stom66.github.io/tts-castle-wars/",
        workshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=2386624320",
        tutorial = "https://youtu.be/UaxvaV5BoTI"
    }
    page = page or "wiki"
    if not pages[page] then return false end

    if not data.tablet_obj then
        tablet_spawnTablet(page, player_color)
    else
        data.tablet_obj.Browser.url = pages[page]
        if player_color ~= "Grey" then
            Player[player_color].lookAt({
                position = data.tablet_obj.getPosition(),
                pitch    = 45,
                yaw      = 180,
                distance = 8,
            })
        end
    end
end
