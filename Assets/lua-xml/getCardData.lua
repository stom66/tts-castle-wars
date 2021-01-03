--[[
    This function returns the data for all the cards used by the game. 
    Indexes must match the card IDs as they appear in the save file.

    Costs are in lphabetical rder,eg {bricks, crystals, swords}
     - {0, 0, 5} = 5 swords
     - {10, 0, 0} = 10 bricks
]]
function getCardData()
    local t = {}
    t[100]     = { 
        name   = "Add Bricks",
        cost   = {0, 5, 0, 0},
        action = "attack6"
    }
    t[101]     = { 
        name   = "Add Crystals",
        cost   = {0, 5, 0, 0},
        action = "attack6"
    }
    t[102]     = { 
        name   = "Add Weapons",
        cost   = {0, 5, 0, 0},
        action = "attack6"
    }
    t[103]     = { 
        name   = "All Bricks",
        cost   = {1, 0, 0, 0},
        action = "attack6"
    }
    t[104]     = { 
        name   = "All Crystals",
        cost   = {0, 1, 0, 0},
        action = "attack6"
    }
    t[105]     = { 
        name   = "All Weapons",
        cost   = {0, 0, 1, 0},
        action = "attack6"
    }
    t[106]     = { 
        name   = "Ambush",
        cost   = {0, 0, 20,0},
        action = "attack6"
    }
    t[107]     = { 
        name   = "Archer",
        cost   = {0, 0, 1, 0},
        action = "attack6"
    }
    t[108]     = { 
        name   = "Babylon",
        cost   = {28,0, 0, 0},
        action = "attack6"
    }
    t[109]     = { 
        name   = "Battering Ram",
        cost   = {7, 0, 0, 0},
        action = "attack6"
    }
    t[110]     = { 
        name   = "Bomb",
        cost   = {0, 0, 14,0},
        action = "attack6"
    }
    t[111]     = { 
        name   = "Bribe Builder",
        cost   = {22,0, 0, 0},
        action = "attack6"
    }
    t[112]     = { 
        name   = "Bribe Mage",
        cost   = {0, 22,0, 0},
        action = "attack6"
    }
    t[113]     = { 
        name   = "Bribe Recruit",
        cost   = {0, 0, 22,0},
        action = "attack6"
    }
    t[114]     = { 
        name   = "Builder",
        cost   = {8, 0, 0, 0},
        action = "attack6"
    }
    t[115]     = { 
        name   = "Cannon",
        cost   = {0, 0, 16,0},
        action = "attack6"
    }
    t[116]     = { 
        name   = "Catapult",
        cost   = {10,0, 0, 0},
        action = "attack6"
    }
    t[117]     = { 
        name   = "Comet Strike",
        cost   = {20,10,0, 0},
        action = "attack6"
    }
    t[118]     = { 
        name   = "Curse",
        cost   = {18,18,18,0},
        action = "attack6"
    }
    t[119]     = { 
        name   = "Dispel",
        cost   = {2, 2, 2, 0},
        action = "attack6"
    }
    t[200]     = { 
        name   = "Dragon",
        cost   = {20,20,0, 0},
        action = "attack6"
    }
    t[201]     = { 
        name   = "Fence",
        cost   = {5, 0, 0, 0},
        action = "attack6"
    }
    t[202]     = { 
        name   = "Fire Archer",
        cost   = {0, 0, 3, 0},
        action = "attack6"
    }
    t[203]     = { 
        name   = "Giant Snowball",
        cost   = {6, 6, 0, 0},
        action = "attack6"
    }
    t[204]     = { 
        name   = "Guards",
        cost   = {0, 0, 7, 0},
        action = "attack6"
    }
    t[205]     = { 
        name   = "Hail Storm",
        cost   = {0, 14,0, 0},
        action = "attack6"
    }
    t[206]     = { 
        name   = "House",
        cost   = {5, 0, 0, 0},
        action = "attack6"
    }
    t[207]     = { 
        name   = "Knight",
        cost   = {0, 0, 10,0},
        action = "attack6"
    }
    t[208]     = { 
        name   = "Large Wall",
        cost   = {14,0, 0, 0},
        action = "attack6"
    }
    t[209]     = { 
        name   = "Lightning",
        cost   = {0, 20,0, 0},
        action = "attack6"
    }
    t[210]     = { 
        name   = "Mage",
        cost   = {0, 8, 0, 0},
        action = "attack6"
    }
    t[211]     = { 
        name   = "Magic Bricks",
        cost   = {0, 16,0, 0},
        action = "attack6"
    }
    t[212]     = { 
        name   = "Magic Defence",
        cost   = {0, 10,0, 0},
        action = "attack6"
    }
    t[213]     = { 
        name   = "Conjure Wall",
        cost   = {0, 15,0, 0},
        action = "attack6"
    }
    t[214]     = { 
        name   = "Magic Weapons",
        cost   = {0, 14,0, 0},
        action = "attack6"
    }
    t[215]     = { 
        name   = "Pixies",
        cost   = {0, 18,0, 0},
        action = "attack6"
    }
    t[216]     = { 
        name   = "Platoon",
        cost   = {0, 0, 7, 0},
        action = "attack6"
    }
    t[217]     = { 
        name   = "Protect Resources",
        cost   = {0, 0, 4, 0},
        action = "attack6"
    }
    t[218]     = { 
        name   = "Quake",
        cost   = {0, 24,0, 0},
        action = "attack6"
    }
    t[219]     = { 
        name   = "Ram Attack",
        cost   = {4, 0, 4, 0},
        action = "attack6"
    }
    t[300]     = { 
        name   = "Recruit",
        cost   = {0, 0, 8, 0},
        action = "attack6"
    }
    t[301]     = { 
        name   = "Remove Bricks",
        cost   = {0, 5, 0, 0},
        action = "attack6"
    }
    t[302]     = { 
        name   = "Remove Crystals",
        cost   = {0, 5, 0, 0},
        action = "attack6"
    }
    t[303]     = { 
        name   = "Remove Resources",
        cost   = {5, 5, 5, 0},
        action = "attack6"
    }
    t[304]     = { 
        name   = "Remove Weapons",
        cost   = {0, 5, 0, 0},
        action = "attack6"
    }
    t[305]     = { 
        name   = "Reverse",
        cost   = {3, 0, 0, 4},
        action = "attack6"
    }
    t[306]     = { 
        name   = "Reward Workers",
        cost   = {1, 1, 1, 0},
        action = "attack6"
    }
    t[307]     = { 
        name   = "Roadblock",
        cost   = {0, 0, 8, 0},
        action = "attack6"
    }
    t[308]     = { 
        name   = "Sabotage",
        cost   = {0, 0, 10,0},
        action = "attack6"
    }
    t[309]     = { 
        name   = "School",
        cost   = {30,0, 0, 0},
        action = "attack6"
    }
    t[310]     = { 
        name   = "Tavern",
        cost   = {12,0, 0, 0},
        action = "attack6"
    }
    t[311]     = { 
        name   = "Thief",
        cost   = {0, 0, 17,0},
        action = "attack6"
    }
    t[312]     = { 
        name   = "Tower",
        cost   = {10,0, 0, 0},
        action = "attack6"
    }
    t[313]     = { 
        name   = "Trojan Horse",
        cost   = {14,0, 20,0},
        action = "attack6"
    }
    t[314]     = { 
        name   = "Wain",
        cost   = {10,0, 0, 0},
        action = "attack6"
    }
    t[315]     = { 
        name   = "Wall",
        cost   = {4, 0, 0, 0},
        action = "attack6"
    }
    return t
end