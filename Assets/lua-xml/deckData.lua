function deck_getDataTable()
    --[[
        This function returns the data for all the spawnable decks
        Indexes must match the card IDs as they appear in the save file.
    --]]
    
    local names = {
        "Stock", "Full", "Stock Plus"
    }
    local cards = {}
    cards[148900] = {4, 5, 4}
    cards[148901] = {4, 5, 4}
    cards[148902] = {5, 5, 5}
    cards[149100] = {2, 5, 2}
    cards[148903] = {3, 5, 3}
    cards[149000] = {2, 5, 2}
    cards[149001] = {4, 5, 4}
    cards[149002] = {2, 5, 2}
    cards[149101] = {4, 5, 4}
    cards[149102] = {5, 5, 5}
    cards[149003] = {5, 5, 5}
    cards[149103] = {2, 5, 2}
    cards[148904] = {2, 5, 2}
    cards[149004] = {2, 5, 2}
    cards[149104] = {5, 5, 5}
    cards[149005] = {4, 5, 4}
    cards[149105] = {2, 5, 2}
    cards[149200] = {0, 5, 2}
    cards[148905] = {4, 5, 4}
    cards[149201] = {2, 5, 2}
    cards[149202] = {0, 5, 2}
    cards[149203] = {2, 5, 2}
    cards[149106] = {5, 5, 5}
    cards[149006] = {3, 5, 3}
    cards[149204] = {0, 5, 2}
    cards[149007] = {4, 5, 4}
    cards[148906] = {2, 5, 2}
    cards[149107] = {3, 5, 3}
    cards[149008] = {2, 5, 2}
    cards[149108] = {4, 5, 4}
    cards[148907] = {3, 5, 3}
    cards[148908] = {5, 5, 5}
    cards[148909] = {2, 5, 2}
    cards[148910] = {2, 5, 2}
    cards[148911] = {2, 5, 2}
    cards[148912] = {2, 5, 2}
    cards[149009] = {4, 5, 4}
    cards[149010] = {2, 5, 2}
    cards[148913] = {2, 5, 2}
    cards[149205] = {2, 5, 2}
    cards[149011] = {5, 5, 5}
    cards[148914] = {2, 5, 2}
    cards[148915] = {2, 5, 2}
    cards[149206] = {2, 5, 2}
    cards[148916] = {2, 5, 2}
    cards[149109] = {2, 5, 2}
    cards[149207] = {0, 5, 5}
    cards[149012] = {2, 5, 2}
    cards[149013] = {1, 5, 1}
    cards[149110] = {2, 5, 2}
    cards[149111] = {3, 5, 3}
    cards[149014] = {2, 5, 2}
    cards[149112] = {3, 5, 3}
    cards[149208] = {0, 5, 2}
    cards[149113] = {2, 5, 2}
    return {
        names = names,
        cards = cards
    }
end