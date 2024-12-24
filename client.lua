local QBCore = exports['qb-core']:GetCoreObject()

local npcCoords1 = vector4(325.98, -214.12, 54.09, 165.05)
local targetCoords1 = vector3(754.28, -247.65, 66.11)

local npcCoords2 = vector4(753.56, -247.17, 66.11, 337.58)
local targetCoords2 = vector3(334.56, -207.57, 54.09)

local npcModel = `a_f_m_fatbla_01`

local teleportCooldown = {}

CreateThread(function()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(10)
    end

    local npc1 = CreatePed(0, npcModel, npcCoords1.x, npcCoords1.y, npcCoords1.z - 1, npcCoords1.w, false, false)
    SetEntityInvincible(npc1, true)
    FreezeEntityPosition(npc1, true)
    SetBlockingOfNonTemporaryEvents(npc1, true)

    exports["qb-target"]:AddTargetEntity(npc1, {
        options = {
            {
                event = "custom:goToFootballField",
                icon = "fas fa-gear",
                label = "FARM",
            },
        },
        distance = 2.5,
    })

    local npc2 = CreatePed(0, npcModel, npcCoords2.x, npcCoords2.y, npcCoords2.z - 1, npcCoords2.w, false, false)
    SetEntityInvincible(npc2, true)
    FreezeEntityPosition(npc2, true)
    SetBlockingOfNonTemporaryEvents(npc2, true)

    exports["qb-target"]:AddTargetEntity(npc2, {
        options = {
            {
                event = "custom:goToMainField",
                icon = "fas fa-gear",
                label = "MOTEL",
            },
        },
        distance = 2.5,
    })
end)

local function isOnCooldown(playerId, event)
    if teleportCooldown[playerId] and teleportCooldown[playerId][event] then
        return GetGameTimer() < teleportCooldown[playerId][event]
    end
    return false
end

local function setCooldown(playerId, event, duration)
    if not teleportCooldown[playerId] then
        teleportCooldown[playerId] = {}
    end
    teleportCooldown[playerId][event] = GetGameTimer() + duration
end

RegisterNetEvent("custom:goToFootballField", function()
    local playerId = PlayerPedId()
    local eventName = "custom:goToFootballField"

    if isOnCooldown(playerId, eventName) then
        --QBCore.Functions.Notify("Bu işlemi tekrar yapabilmek için biraz beklemen gerekiyor!", "error")
        return
    end

    SetEntityCoords(playerId, targetCoords1.x, targetCoords1.y, targetCoords1.z)
    --QBCore.Functions.Notify("Futbol sahasına ışınlandın!", "success")

    setCooldown(playerId, eventName, 0) -- 30 seconds
end)

RegisterNetEvent("custom:goToMainField", function()
    local playerId = PlayerPedId()
    local eventName = "custom:goToMainField"

    if isOnCooldown(playerId, eventName) then
        --QBCore.Functions.Notify("Bu işlemi tekrar yapabilmek için biraz beklemen gerekiyor!", "error")
        return
    end

    SetEntityCoords(playerId, targetCoords2.x, targetCoords2.y, targetCoords2.z)
    --QBCore.Functions.Notify("Ana sahaya ışınlandın!", "success")

    setCooldown(playerId, eventName, 30000) -- 30 seconds
end)
