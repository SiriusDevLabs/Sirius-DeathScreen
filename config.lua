Config = {
    ReviveAce = "sirius.revive",
    RespawnAce = "sirius.respawn",
    Blur = true, -- Enables blur when player die
    Controls = {
        Mouse = true,
        Enable = {245, 38, 0, 322, 288, 213, 249, 46, 47}
    },
    RespawnLocations = {
        ['Los Santos'] = {
            --Pillbox Hill Medical Center
            x = 298.2,
            y = -584.17,
            z = 43.26,
        },
        ['Sandy Shores'] = {
            --Sandy Shores Medical Center
            x = 1841.0413,
            y = 3670.0869,
            z = 33.6801,
        },

        ['Paleto Bay'] = {
            --Paleto Bay Medical Center
            x = -248.1,
            y = 6332.6,
            z = 32.43,
        },
    },

    DeadlyMelee = {
        [GetHashKey("weapon_dagger")] = true,
        [GetHashKey("weapon_battleaxe")] = true,
        [GetHashKey("weapon_hatchet")] = true,
        [GetHashKey("weapon_knife")] = true,
        [GetHashKey("weapon_machete")] = true,
        [GetHashKey("weapon_stone_hatchet")] = true,
        [GetHashKey("weapon_switchblade")] = true,
        [GetHashKey("WEAPON_AXE")] = true,
        [GetHashKey("WEAPON_BUTTERFLYKNIFE")] = true,
        [GetHashKey("WEAPON_FIREAXE")] = true,
        [GetHashKey("WEAPON_KARAMBIT")] = true,
        [GetHashKey("WEAPON_SCREWDRIVER")] = true,
        [GetHashKey("WEAPON_ZKKNIFE")] = true,
        [GetHashKey("WEAPON_SHURIKEN")] = true,
        [GetHashKey("weapon_grenade")] = true,
        [GetHashKey("weapon_molotov")] = true,
        [GetHashKey("weapon_pipebomb")] = true,
        [GetHashKey("weapon_proxmine")] = true,
        [GetHashKey("weapon_stickybomb")] = true,
        [GetHashKey("weapon_knuckle")] = true
    },
}