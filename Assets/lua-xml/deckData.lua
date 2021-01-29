function deck_getDataTable()
    --[[
        This function returns the data for all the spawnable decks
        Indexes must match the card IDs as they appear in the save file.
    --]]

    --define deck names
    local names = {
        "Complete", "Stock", "Stock Plus"
    }

    --define card counts for the decks
    local cards = {}
    cards[148900] = {5, 4, 4} -- Add Bricks
    cards[148901] = {5, 4, 4} -- Add Crystals
    cards[148902] = {5, 5, 5} -- Add Weapons
    cards[149100] = {5, 2, 2} -- All Bricks
    cards[148903] = {5, 3, 3} -- All Crystals
    cards[149000] = {5, 2, 2} -- All Weapons
    cards[149001] = {5, 4, 4} -- Ambush
    cards[149002] = {5, 2, 2} -- Archer
    cards[149101] = {5, 4, 4} -- Babylon
    cards[149102] = {5, 5, 5} -- Battering Ram
    cards[149003] = {5, 5, 5} -- Bomb
    cards[149103] = {5, 2, 2} -- Bribe Builder
    cards[148904] = {5, 2, 2} -- Bribe Mage
    cards[149004] = {5, 2, 2} -- Bribe Recruit
    cards[149104] = {5, 5, 5} -- Builder
    cards[149005] = {5, 4, 4} -- Cannon
    cards[149105] = {5, 2, 2} -- Catapult
    cards[149200] = {5, 0, 2} -- Comet Strike
    cards[148905] = {5, 4, 4} -- Conjure Wall
    cards[149201] = {5, 2, 2} -- Curse
    cards[149202] = {5, 0, 2} -- Dispel
    cards[149203] = {5, 2, 2} -- Dragon
    cards[149106] = {5, 5, 5} -- Fence
    cards[149006] = {5, 3, 3} -- Fire Archer
    cards[149204] = {5, 0, 2} -- Giant Snowball
    cards[149007] = {5, 4, 4} -- Guards
    cards[148906] = {5, 2, 2} -- Hail Storm
    cards[149107] = {5, 3, 3} -- House
    cards[149008] = {5, 2, 2} -- Knight
    cards[149108] = {5, 4, 4} -- Large Wall
    cards[148907] = {5, 3, 3} -- Lightning
    cards[148908] = {5, 5, 5} -- Mage
    cards[148909] = {5, 2, 2} -- Magic Bricks
    cards[148910] = {5, 2, 2} -- Magic Defence
    cards[148911] = {5, 2, 2} -- Magic Weapons
    cards[148912] = {5, 2, 2} -- Pixies
    cards[149009] = {5, 4, 4} -- Platoon
    cards[149010] = {5, 2, 2} -- Protect Resources
    cards[148913] = {5, 2, 2} -- Quake
    cards[149205] = {5, 2, 2} -- Ballista
    cards[149011] = {5, 5, 5} -- Recruit
    cards[148914] = {5, 2, 2} -- Remove Bricks
    cards[148915] = {5, 2, 2} -- Remove Crystals
    cards[149206] = {5, 2, 2} -- Remove Resources
    cards[148916] = {5, 2, 2} -- Remove Weapons
    cards[149109] = {5, 2, 2} -- Reverse
    cards[149207] = {5, 0, 5} -- Reward Workers
    cards[149012] = {5, 2, 2} -- Roadblock
    cards[149013] = {5, 1, 1} -- Sabotage
    cards[149110] = {5, 2, 2} -- School
    cards[149111] = {5, 3, 3} -- Tavern
    cards[149014] = {5, 2, 2} -- Thief
    cards[149112] = {5, 3, 3} -- Tower
    cards[149208] = {5, 0, 2} -- Trojan Horse
    cards[149113] = {5, 2, 2} -- Wain
    cards[149114] = {5, 5, 5} -- Wall

    if data.debug then
        log("deck_getDataTable(): returned "..#names.." combinations of decks from "..#cards.." cards", nil, "info")
    end

    return {
        names = names,
        cards = cards
    }
end