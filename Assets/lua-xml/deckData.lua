function deck_getDataTable()
    --[[
        This function returns the data for all the spawnable decks
        Indexes must match the card IDs as they appear in the save file.
    --]]

    --define deck names
    local names = {
        "Stock Plus", "Stock", "Complete", "Empty"
    }

    --define card counts for the decks
    local cards = {}
    cards[148900] = {4, 4, 5, 0} -- Add Bricks
    cards[148901] = {4, 4, 5, 0} -- Add Crystals
    cards[148902] = {5, 5, 5, 0} -- Add Weapons
    cards[149100] = {2, 2, 5, 0} -- All Bricks
    cards[148903] = {3, 3, 5, 0} -- All Crystals
    cards[149000] = {2, 2, 5, 0} -- All Weapons
    cards[149001] = {4, 4, 5, 0} -- Ambush
    cards[149002] = {2, 2, 5, 0} -- Archer
    cards[149101] = {4, 4, 5, 0} -- Babylon
    cards[149102] = {5, 5, 5, 0} -- Battering Ram
    cards[149003] = {5, 5, 5, 0} -- Bomb
    cards[149103] = {2, 2, 5, 0} -- Bribe Builder
    cards[148904] = {2, 2, 5, 0} -- Bribe Mage
    cards[149004] = {2, 2, 5, 0} -- Bribe Recruit
    cards[149104] = {5, 5, 5, 0} -- Builder
    cards[149005] = {4, 4, 5, 0} -- Cannon
    cards[149105] = {2, 2, 5, 0} -- Catapult
    cards[149200] = {2, 0, 5, 0} -- Comet Strike
    cards[148905] = {4, 4, 5, 0} -- Conjure Wall
    cards[149201] = {2, 2, 5, 0} -- Curse
    cards[149202] = {2, 0, 5, 0} -- Dispel
    cards[149203] = {2, 2, 5, 0} -- Dragon
    cards[149106] = {5, 5, 5, 0} -- Fence
    cards[149006] = {3, 3, 5, 0} -- Fire Archer
    cards[149204] = {2, 0, 5, 0} -- Giant Snowball
    cards[149007] = {4, 4, 5, 0} -- Guards
    cards[148906] = {2, 2, 5, 0} -- Hail Storm
    cards[149107] = {3, 3, 5, 0} -- House
    cards[149008] = {2, 2, 5, 0} -- Knight
    cards[149108] = {4, 4, 5, 0} -- Large Wall
    cards[148907] = {3, 3, 5, 0} -- Lightning
    cards[148908] = {5, 5, 5, 0} -- Mage
    cards[148909] = {2, 2, 5, 0} -- Magic Bricks
    cards[148910] = {2, 2, 5, 0} -- Magic Defence
    cards[148911] = {2, 2, 5, 0} -- Magic Weapons
    cards[148912] = {2, 2, 5, 0} -- Pixies
    cards[149009] = {4, 4, 5, 0} -- Platoon
    cards[149010] = {2, 2, 5, 0} -- Protect Resources
    cards[148913] = {2, 2, 5, 0} -- Quake
    cards[149205] = {2, 2, 5, 0} -- Ballista
    cards[149011] = {5, 5, 5, 0} -- Recruit
    cards[148914] = {2, 2, 5, 0} -- Remove Bricks
    cards[148915] = {2, 2, 5, 0} -- Remove Crystals
    cards[149206] = {2, 2, 5, 0} -- Remove Resources
    cards[148916] = {2, 2, 5, 0} -- Remove Weapons
    cards[149109] = {2, 2, 5, 0} -- Reverse
    cards[149207] = {5, 0, 5, 0} -- Reward Workers
    cards[149012] = {2, 2, 5, 0} -- Roadblock
    cards[149013] = {1, 1, 5, 0} -- Sabotage
    cards[149110] = {2, 2, 5, 0} -- School
    cards[149111] = {3, 3, 5, 0} -- Tavern
    cards[149014] = {2, 2, 5, 0} -- Thief
    cards[149112] = {3, 3, 5, 0} -- Tower
    cards[149208] = {2, 0, 5, 0} -- Trojan Horse
    cards[149113] = {2, 2, 5, 0} -- Wain
    cards[149114] = {5, 5, 5, 0} -- Wall

    if data.debug then
        log("deck_getDataTable(): returned "..#names.." combinations of decks from "..#cards.." cards", nil, "info")
    end

    return {
        names = names,
        cards = cards
    }
end