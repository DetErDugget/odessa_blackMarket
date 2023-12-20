Config = {}
Config.Locale = {}
Config.AllowEveryone = false -- True = Allow everyone to use the shop. False = Only allow gangs to use the shop
Config.Items = {
    ["WEAPON_PISTOL"] = {amount = 1, price = 59499, restockTimer = 3}, -- Restock timer is in hours
    ["PISTOL_SUPPRESSOR"] = {amount = 1, price = 8888, restockTimer = 3},
    ["WEAPON_BATTLEAXE"] = {amount = 1, price = 12000, restockTimer = 13},
    ["WEAPON_SNSPISTOL"] = {amount = 1, price = 33000, restockTimer = 3},
    ["WEAPON_DBSHOTGUN"] = {amount = 2, price = 25000, restockTimer = 3},
    ["WEAPON_SWITCHBLADE"] = {amount = 2, price = 25000, restockTimer = 3},
}
Config.Lang = "DK" -- DK or EN

Config.PedModel = "a_m_m_hillbilly_01"
Config.PedCoords = vector4(-172.92, 6144.49, 42.64, 32.73)
Config.SoundCoords = vector3(-172.92, 6144.49, 42.64)
Config.CrateModel = "gr_prop_gr_crate_pistol_02a"
Config.CratePos = vector3(-174.13, 6143.3, 42.64)
Config.LookH = 207.34


Config.Locale["DK"] = {
    -- Server
    Boughta = "Du har købt en ",
    For = " for ",
    Currency = " DKK",
    NotEnoughSpace = "Du har ikke plads...",
    NotEnoughCash = "Du har ikke nok kontanter...",
    Busy = "En af gangen...",


    --Client
    WhatsInBox = "Hva har du i kassen?",
    StockPrice = " på lager.\n\n Pris: ",
    OutOfStock = "Jeg har ikke flere lige nu..",
    Greetings = "Jaja!",
    NPCName = "Gorm Gylle",
    NoGang = "Jaja! Goddag, jeg har ikke noget i kassen.",
    WonnaTrade = "Vil du handle?",
    Is = " koster ",
    FindItForYou = "Jaja! Finder den til dig.",
    RejectedBuy = "Københavner der ikk vil handle. Jaja!",
}

Config.Locale["EN"] = {
    -- Server
    Boughta = "You've bought a ",
    For = " for ",
    Currency = " $",
    NotEnoughSpace = "You don't have enough space...",
    NotEnoughCash = "You don't have enough cash...",
    Busy = "Busy...",


    --Client
    WhatsInBox = "What do you have in the box?",
    StockPrice = " in stock.\n\n Price: ",
    OutOfStock = "I don't have anymore right now..",
    Greetings = "Hello!",
    NPCName = "Eric Clapsoul",
    NoGang = "I've nothing in this box!",
    WonnaTrade = "It's a deal?",
    Is = " kosts ",
    FindItForYou = "I'll find it for you...",
    RejectedBuy = "You forgot your wallet?",
}
