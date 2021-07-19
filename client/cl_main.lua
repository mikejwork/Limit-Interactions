-- http://gtahash.site/?s=121155 -- for prop names / hash
-- icons https://fontawesome.com/icons

InteractZones = {}

local active = false
local cursorBeingUsed = false
local resetOnce = false
local playerIsArmed = false

function toggleInteract(bool)
    active = bool
    SendNUIMessage({
        type = "toggle",
        bool = bool
    })
end

function updateAll()
    SendNUIMessage({
        type = "refresh",
        arr = InteractZones
    })
end

function resetAll()
    SendNUIMessage({
        type = "reset"
    })
end

function startLoops()
    -- Prop interact loop
    Citizen.CreateThread(function() 
        while true do
            Citizen.Wait(250)
            if active then
                SetPlayerForcedAim(PlayerId(), true)

                local retval , entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                local location = GetEntityCoords(PlayerPedId())
                local hash = GetEntityModel(entity)

                for i = 1, #InteractZones, 1 do
                    if InteractZones[i].type == 'prop' then
                        if hash == GetHashKey(InteractZones[i].prop) then
                            local dist = GetDistanceBetweenCoords(location, GetEntityCoords(entity), true)
                            if dist <= InteractZones[i].radius then
                                InteractZones[i].active = true
                                goto continue
                            end
                        end
                        InteractZones[i].active = false
                        ::continue::
                    elseif InteractZones[i].type == 'zone' then
                        local dist = GetDistanceBetweenCoords(location, InteractZones[i].coordinates, true)
                        if dist <= InteractZones[i].radius then
                            InteractZones[i].active = true
                            goto continue
                        end
                        InteractZones[i].active = false
                        ::continue::
                    end
                end
                updateAll()
                resetOnce = false
            else
                if not resetOnce then
                    resetAll()
                    SetPlayerForcedAim(PlayerId(), false)
                    resetOnce = true
                end
            end
        end
    end)

    -- Main control loop
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if not playerIsArmed then
                if active then
                    DisableControlAction(0,24, true) -- Disable attack
                    DisableControlAction(0,25, true) -- Disable aim
                    DisableControlAction(0,14, true) -- {
                    DisableControlAction(0,15, true) --     Disable scroll / numbers for weapon selecting.
                    DisableControlAction(0,16, true) --     prevents players using the interact icon as a crosshair.
                    DisableControlAction(0,17, true) -- }
                    if cursorBeingUsed then
                        -- Disable looking when selecting an option.
                        DisableControlAction(0, 1, true) -- LookLeftRight
                        DisableControlAction(0, 2, true) -- LookUpDown
                    end

                    if IsControlJustReleased(0, 19) then
                        toggleInteract(false)
                        SetNuiFocus(false, false)
                        SetNuiFocusKeepInput(false)
                        cursorBeingUsed = false
                    end 
    
                    if IsControlJustPressed(0, 68) then
                        SetNuiFocus(true, true)
                        SetNuiFocusKeepInput(true)
                        cursorBeingUsed = true
                        SetCursorLocation(0.5, 0.5)
                    end
                end

                if IsControlJustPressed(0, 19) then
                    toggleInteract(true)
                    PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                end
            else
                if active then
                    toggleInteract(false)
                    SetNuiFocus(false, false)
                    SetNuiFocusKeepInput(false)
                    cursorBeingUsed = false
                end
            end
        end
    end)

    Citizen.CreateThread(function() 
        while true do
            Citizen.Wait(1000)
            if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("weapon_unarmed") then
                playerIsArmed = true
            else
                playerIsArmed = false
            end
        end
    end)
end

RegisterNetEvent('limit:charactermanager_spawned')
AddEventHandler('limit:charactermanager_spawned', function()
    print('cl_event @limit:charactermanager_spawned')

    -- TriggerEvent('limit:interacts_addInteractProp', 'prop_atm_03', 4, 'atm_red', 'Access ATM', 'fas fa-wallet', function()
    --     print('atm_red : Accessed')
    -- end)

    startLoops()
    updateAll()
    resetAll()
end)

-- Add an interact based on zone.
-- will trigger callback if player is inside the zone while in the interact menu
RegisterNetEvent('limit:interacts_addInteractZone')
AddEventHandler('limit:interacts_addInteractZone', function(zone_coordinates, zone_radius, interact_name, interact_label, interact_icon, callback)
    print('cl_event @limit:interacts_addInteractZone => ' .. interact_name)
    local zone = {}
    zone.type = 'zone'
    zone.name = name
    zone.label = interact_label
    zone.icon = interact_icon
    zone.radius = zone_radius
    zone.coordinates = zone_coordinates
    zone.callback = callback
    zone.active = false

    InteractZones[#InteractZones + 1] = zone
    SendNUIMessage({
        type = "addZone",
        zone = zone
    })
    updateAll()
end)

-- Add an interact based on prop
-- will trigger callback if player is inside the zone near the specified prop
RegisterNetEvent('limit:interacts_addInteractProp')
AddEventHandler('limit:interacts_addInteractProp', function(prop_hash, zone_radius, interact_name, interact_label, interact_icon, callback)
    print('cl_event @limit:interacts_addInteractProp => ' .. interact_name)
    local zone = {}
    zone.type = 'prop'
    zone.name = name
    zone.label = interact_label
    zone.icon = interact_icon
    zone.radius = zone_radius
    zone.prop = prop_hash
    zone.callback = callback
    zone.active = false

    InteractZones[#InteractZones + 1] = zone
    SendNUIMessage({
        type = "addZone",
        zone = zone
    })
    updateAll()
end)

RegisterNUICallback("select", function(data)
    InteractZones[tonumber(data.index + 1)].callback()
end)