function deck_getDataTable()
    --[[
        This function returns the data for all the spawnable decks
        Indexes must match the card IDs as they appear in the save file.
    --]]

    --define deck names
    local names = {
        "Stock Plus", "Stock", "Complete", "Empty", "Rush", "Turtle", "Burn"
    }

    --define card counts for the decks
    local cards = {}
    cards[148900] = {4, 4, 5, 0, 3, 4, 4} -- Add Bricks
    cards[148901] = {4, 4, 5, 0, 3, 4, 4} -- Add Crystals
    cards[148902] = {5, 5, 5, 0, 3, 4, 4} -- Add Weapons
    cards[149100] = {2, 2, 5, 0, 0, 2, 0} -- All Bricks
    cards[148903] = {3, 3, 5, 0, 0, 2, 0} -- All Crystals
    cards[149000] = {2, 2, 5, 0, 0, 0, 0} -- All Weapons
    cards[149001] = {4, 4, 5, 0, 1, 2, 3} -- Ambush
    cards[149002] = {2, 2, 5, 0, 3, 0, 1} -- Archer
    cards[149101] = {4, 4, 5, 0, 0, 3, 0} -- Babylon
    cards[149102] = {5, 5, 5, 0, 3, 2, 0} -- Battering Ram
    cards[149003] = {5, 5, 5, 0, 2, 0, 1} -- Bomb
    cards[149103] = {2, 2, 5, 0, 0, 1, 2} -- Bribe Builder
    cards[148904] = {2, 2, 5, 0, 0, 1, 2} -- Bribe Mage
    cards[149004] = {2, 2, 5, 0, 0, 1, 2} -- Bribe Recruit
    cards[149104] = {5, 5, 5, 0, 5, 5, 5} -- Builder
    cards[149005] = {4, 4, 5, 0, 2, 1, 0} -- Cannon
    cards[149105] = {2, 2, 5, 0, 3, 2, 0} -- Catapult
    cards[149200] = {2, 0, 5, 0, 0, 0, 2} -- Comet Strike
    cards[148905] = {4, 4, 5, 0, 0, 5, 2} -- Conjure Wall
    cards[149201] = {2, 2, 5, 0, 0, 2, 3} -- Curse
    cards[149202] = {2, 0, 5, 0, 2, 3, 4} -- Dispel
    cards[149203] = {2, 2, 5, 0, 0, 0, 1} -- Dragon
    cards[149106] = {5, 5, 5, 0, 3, 5, 5} -- Fence
    cards[149006] = {3, 3, 5, 0, 2, 2, 0} -- Fire Archer
    cards[149204] = {2, 0, 5, 0, 3, 2, 1} -- Giant Snowball
    cards[149007] = {4, 4, 5, 0, 3, 5, 5} -- Guards
    cards[148906] = {2, 2, 5, 0, 4, 0, 2} -- Hail Storm
    cards[149107] = {3, 3, 5, 0, 0, 3, 0} -- House
    cards[149008] = {2, 2, 5, 0, 3, 0, 0} -- Knight
    cards[149108] = {4, 4, 5, 0, 0, 5, 3} -- Large Wall
    cards[148907] = {3, 3, 5, 0, 0, 0, 1} -- Lightning
    cards[148908] = {5, 5, 5, 0, 5, 5, 5} -- Mage
    cards[148909] = {2, 2, 5, 0, 0, 5, 2} -- Magic Bricks
    cards[148910] = {2, 2, 5, 0, 2, 5, 4} -- Magic Defence
    cards[148911] = {2, 2, 5, 0, 1, 0, 3} -- Magic Weapons
    cards[148912] = {2, 2, 5, 0, 0, 5, 0} -- Pixies
    cards[149009] = {4, 4, 5, 0, 3, 1, 0} -- Platoon
    cards[149010] = {2, 2, 5, 0, 2, 5, 5} -- Protect Resources
    cards[148913] = {2, 2, 5, 0, 0, 0, 1} -- Quake
    cards[149205] = {2, 2, 5, 0, 3, 2, 0} -- Ballista
    cards[149011] = {5, 5, 5, 0, 5, 5, 5} -- Recruit
    cards[148914] = {2, 2, 5, 0, 2, 2, 5} -- Remove Bricks
    cards[148915] = {2, 2, 5, 0, 2, 2, 5} -- Remove Crystals
    cards[149206] = {2, 2, 5, 0, 2, 2, 5} -- Remove Resources
    cards[148916] = {2, 2, 5, 0, 2, 2, 5} -- Remove Weapons
    cards[149109] = {2, 2, 5, 0, 0, 3, 5} -- Reverse
    cards[149207] = {5, 0, 5, 0, 5, 5, 5} -- Reward Workers
    cards[149012] = {2, 2, 5, 0, 0, 2, 3} -- Roadblock
    cards[149013] = {1, 1, 5, 0, 0, 0, 3} -- Sabotage
    cards[149110] = {2, 2, 5, 0, 0, 1, 0} -- School
    cards[149111] = {3, 3, 5, 0, 0, 5, 1} -- Tavern
    cards[149014] = {2, 2, 5, 0, 2, 2, 5} -- Thief
    cards[149112] = {3, 3, 5, 0, 0, 4, 0} -- Tower
    cards[149208] = {2, 0, 5, 0, 0, 1, 2} -- Trojan Horse
    cards[149113] = {2, 2, 5, 0, 2, 5, 5} -- Wain
    cards[149114] = {5, 5, 5, 0, 0, 2, 0} -- Wall

    if data.debug then
        log("deck_getDataTable(): returned "..#names.." combinations of decks from "..#cards.." cards", nil, "info")
    end

    return {
        names = names,
        cards = cards
    }
end
























































