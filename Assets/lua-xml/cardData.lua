--[[
    This function returns the data for all the cards used by the game.
    Indexes must match the card IDs as they appear in the save file.

    Costs are in alphabetical order, eg {bricks, crystals, swords, wall}
     - {0, 0, 5, 0} = 5 swords
     - {10, 0, 0, 0} = 10 bricks
]]
function card_getDataTable()
    local t = {}
    t[148900]  = {
        name   = "Add Bricks",
        cost   = {0, 5, 0, 0},
        action = "addResource",
        value  = {8, 0, 0}
    }
    t[148901]  = {
        name   = "Add Crystals",
        cost   = {0, 5, 0, 0},
        action = "addResource",
        value  = {0, 8, 0}
    }
    t[148902]  = {
        name   = "Add Weapons",
        cost   = {0, 5, 0, 0},
        action = "addResource",
        value  = {0, 0, 8}
    }
    t[149100]  = {
        name   = "All Bricks",
        cost   = {1, 0, 0, 0},
        action = "allProduce",
        value  = "bricks"
    }
    t[148903]  = {
        name   = "All Crystals",
        cost   = {0, 1, 0, 0},
        action = "allProduce",
        value  = "crystals"
    }
    t[149000]  = {
        name   = "All Weapons",
        cost   = {0, 0, 1, 0},
        action = "allProduce",
        value  = "swords"
    }
    t[149001]  = {
        name   = "Ambush",
        cost   = {0, 0, 20, 0},
        action = "attack",
        bypass = true,
        value  = 15
    }
    t[149002]  = {
        name   = "Archer",
        cost   = {0, 0, 1, 0},
        action = "attack",
        value  = 2
    }
    t[149101]  = {
        name   = "Babylon",
        cost   = {28, 0, 0, 0},
        action = "buildCastle",
        delay  = 0,
        value  = 30
    }
    t[149102]  = {
        name   = "Battering Ram",
        cost   = {7, 0, 0, 0},
        action = "attack",
        value  = 9,
        delay  = 4.1
    }
    t[149003]  = {
        name   = "Bomb",
        cost   = {0, 0, 14, 0},
        action = "attack",
        value  = 18,
        delay  = 3.5
    }
    t[149103]  = {
        name   = "Bribe Builder",
        cost   = {22, 0, 0, 0},
        action = "stealWorker",
        value  = {1, 0, 0}
    }
    t[148904]  = {
        name   = "Bribe Mage",
        cost   = {0, 22, 0, 0},
        action = "stealWorker",
        value  = {0, 1, 0}
    }
    t[149004]  = {
        name   = "Bribe Recruit",
        cost   = {0, 0, 22, 0},
        action = "stealWorker",
        value  = {0, 0, 1}
    }
    t[149104]  = {
        name   = "Builder",
        cost   = {8, 0, 0, 0},
        action = "addWorker",
        value  = {1, 0, 0}
    }
    t[149005]  = {
        name   = "Cannon",
        cost   = {0, 0, 16, 0},
        action = "attack",
        value  = 20,
        delay  = 0.75
    }
    t[149105]  = {
        name   = "Catapult",
        cost   = {10, 0, 0, 0},
        action = "attack",
        value  = 12,
        delay  = 1.5
    }
    t[149200]  = {
        name   = "Comet Strike",
        cost   = {20, 10, 0, 0},
        action = "attack",
        value  = 30,
        delay  = 3.5
    }
    t[148905]  = {
        name   = "Conjure Wall",
        cost   = {0, 14, 0, 0},
        action = "buildWall",
        bypass = true,
        delay  = 2,
        value  = 20
    }
    t[149201]  = {
        name   = "Curse",
        cost   = {18, 18, 18, 0},
        action = "curse",
        value  = 0
    }
    t[149202]  = {
        name   = "Dispel",
        cost   = {2, 2, 2, 0},
        action = "removeBuff",
        value  = "all"
    }
    t[149203]  = {
        name   = "Dragon",
        cost   = {20, 20, 0, 0},
        action = "attack",
        value  = 38,
        delay  = 3.5
    }
    t[149106]  = {
        name   = "Fence",
        cost   = {5, 0, 0, 0},
        action = "buildWall",
        delay  = 2,
        value  = 9
    }
    t[149006]  = {
        name   = "Fire Archer",
        cost   = {0, 0, 3, 0},
        action = "attack",
        value  = 5,
        delay  = 2.1
    }
    t[149204]  = {
        name   = "Giant Snowball",
        cost   = {6, 6, 0, 0},
        action = "attack",
        value  = 12,
        delay  = 3.5
    }
    t[149007]  = {
        name   = "Guards",
        cost   = {0, 0, 7, 0},
        action = "buildWall",
        delay  = 2,
        bypass = true,
        value  = 12
    }
    t[148906]  = {
        name   = "Hail Storm",
        cost   = {0, 14, 0, 0},
        action = "attack",
        value  = 18,
        delay  = 3.5
    }
    t[149107]  = {
        name   = "House",
        cost   = {5, 0, 0, 0},
        action = "buildCastle",
        delay  = 0,
        value  = 5
    }
    t[149008]  = {
        name   = "Knight",
        cost   = {0, 0, 10, 0},
        action = "attack",
        delay  = 3.5,
        value  = 12
    }
    t[149108]  = {
        name   = "Large Wall",
        cost   = {14, 0, 0, 0},
        action = "buildWall",
        delay  = 2,
        value  = 20
    }
    t[148907]  = {
        name   = "Lightning",
        cost   = {0, 20, 0, 0},
        action = "attack",
        delay  = 3.5,
        value  = 22
    }
    t[148908]  = {
        name   = "Mage",
        cost   = {0, 8, 0, 0},
        action = "addWorker",
        value  = {0, 1, 0}
    }
    t[148909]  = {
        name   = "Magic Bricks",
        cost   = {0, 16, 0, 0},
        action = "addBuff",
        value  = "build"
    }
    t[148910]  = {
        name   = "Magic Defence",
        cost   = {0, 10, 0, 0},
        action = "addBuff",
        value  = "defence"
    }
    t[148911]  = {
        name   = "Magic Weapons",
        cost   = {0, 15, 0, 0},
        action = "addBuff",
        value  = "attack"
    }
    t[148912]  = {
        name   = "Pixies",
        cost   = {0, 18, 0, 0},
        action = "buildCastle",
        delay  = 0,
        bypass = true,
        value  = 22
    }
    t[149009]  = {
        name   = "Platoon",
        cost   = {0, 0, 7, 0},
        action = "attack",
        delay  = 4.25,
        value  = 9
    }
    t[149010]  = {
        name   = "Protect Resources",
        cost   = {0, 0, 4, 0},
        action = "addBuff",
        value  = "resources"
    }
    t[148913]  = {
        name   = "Quake",
        cost   = {0, 24, 0, 0},
        action = "attack",
        delay  = 3.5,
        value  = 27
    }
    t[149205]  = {
        name   = "Ram Attack",
        cost   = {4, 0, 4, 0},
        action = "attack",
        delay  = 3.5,
        value  = 8
    }
    t[149011]  = {
        name   = "Recruit",
        cost   = {0, 0, 8, 0},
        action = "addWorker",
        value  = {0, 0, 1}
    }
    t[148914]  = {
        name   = "Remove Bricks",
        cost   = {0, 5, 0, 0},
        action = "removeResource",
        value  = {8, 0, 0}
    }
    t[148915]  = {
        name   = "Remove Crystals",
        cost   = {0, 5, 0, 0},
        action = "removeResource",
        value  = {0, 8, 0}
    }
    t[149206]  = {
        name   = "Remove Resources",
        cost   = {5, 5, 5, 0},
        action = "removeResource",
        value  = {8, 8, 8}
    }
    t[148916]  = {
        name   = "Remove Weapons",
        cost   = {0, 5, 0, 0},
        action = "removeResource",
        value  = {0, 0, 8}
    }
    t[149109]  = {
        name   = "Reverse",
        cost   = {3, 0, 0, 4},
        action = "buildCastle",
        delay  = 0,
        value  = 8
    }
    t[149207]  = {
        name   = "Reward Workers",
        cost   = {1, 1, 1, 0},
        action = "allProduce",
        value  = "all"
    }
    t[149012]  = {
        name   = "Roadblock",
        cost   = {0, 0, 8, 0},
        action = "allProduce",
        value  = "none"
    }
    t[149013]  = {
        name   = "Sabotage",
        cost   = {0, 0, 10, 0},
        action = "sabotage",
        value  = 0
    }
    t[149110]  = {
        name   = "School",
        cost   = {30, 0, 0, 0},
        action = "addWorker",
        value  = {1, 1, 1}
    }
    t[149111]  = {
        name   = "Tavern",
        cost   = {12, 0, 0, 0},
        action = "buildCastle",
        delay  = 0,
        value  = 15
    }
    t[149014]  = {
        name   = "Thief",
        cost   = {0, 0, 17, 0},
        action = "thief",
        value  = 0
    }
    t[149112]  = {
        name   = "Tower",
        cost   = {10, 0, 0, 0},
        action = "buildCastle",
        delay  = 0,
        value  = 10
    }
    t[149208]  = {
        name   = "Trojan Horse",
        cost   = {14, 0, 20, 0},
        action = "attack",
        delay  = 3.5,
        bypass = true,
        value  = 28
    }
    t[149113]  = {
        name   = "Wain",
        cost   = {10, 0, 0, 0},
        action = "wain",
        value  = 6
    }
    t[149114]  = {
        name   = "Wall",
        cost   = {4, 0, 0, 0},
        action = "buildWall",
        delay  = 2,
        value  = 6
    }
    return t
end