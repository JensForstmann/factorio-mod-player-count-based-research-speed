-- returns the researched lab/research modifier for this force
local function get_researched_modifier(force)
    local speed = 0
    local productivity = 0
    for _, technology in pairs(force.technologies) do
        if technology.upgrade and technology.researched and technology.valid and technology.enabled then
            local technology_prototype = technology.prototype
            for _, mod in pairs(technology_prototype.effects) do
                if mod.type == "laboratory-speed" then
                    speed = speed + mod.modifier * (1 + technology_prototype.max_level - technology_prototype.level)
                end
                if mod.type == "laboratory-productivity" then
                    productivity = productivity +
                    mod.modifier * (1 + technology_prototype.max_level - technology_prototype.level)
                end
            end
        end
    end
    return { speed = speed, productivity = productivity }
end

-- returns the player count based modifier defined in the settings
local function get_player_count_based_settings(player_count)
    local speed = settings.global["speed-for-" .. player_count .. "-player"]
    if speed == nil then
        speed = settings.global["speed-for-more-player"]
    end
    if not settings.global["speed-enabled"].value then
        speed = { value = 1 }
    end

    local productivity = settings.global["productivity-for-" .. player_count .. "-player"]
    if productivity == nil then
        productivity = settings.global["productivity-for-more-player"]
    end
    if not settings.global["productivity-enabled"].value then
        productivity = { value = 1 }
    end

    return { speed = speed.value, productivity = productivity.value };
end

-- refreshes the effects for this force
-- prints a message if it is changed
local function apply(force)
    local previous_laboratory_speed_modifier = force.laboratory_speed_modifier
    local previous_laboratory_productivity_bonus = force.laboratory_productivity_bonus

    -- get the researched values
    local researched_modifier = get_researched_modifier(force)
    local researched_speed_modifer = researched_modifier.speed
    local researched_productivity_bonus = researched_modifier.productivity

    -- get multipliers from settings for the current amount of players
    local player_count = #force.connected_players
    local player_count_based_settings = get_player_count_based_settings(player_count)

    -- calculate new values
    local new_laboratory_speed_modifier = (1 + researched_speed_modifer) * player_count_based_settings.speed - 1
    local new_laboratory_productivity_bonus = (1 + researched_productivity_bonus) *
        player_count_based_settings.productivity - 1
    if new_laboratory_productivity_bonus < 0 then new_laboratory_productivity_bonus = 0 end

    -- apply new values
    force.laboratory_speed_modifier = new_laboratory_speed_modifier
    force.laboratory_productivity_bonus = new_laboratory_productivity_bonus

    -- print notification if values were changed
    if new_laboratory_speed_modifier ~= previous_laboratory_speed_modifier or new_laboratory_productivity_bonus ~= previous_laboratory_productivity_bonus then
        local notification = { "", { "message.change-prefix" } }
        local need_infix = false
        if new_laboratory_speed_modifier ~= previous_laboratory_speed_modifier then
            table.insert(notification, { "message.change-speed", player_count_based_settings.speed })
            need_infix = true
        end
        if new_laboratory_productivity_bonus ~= previous_laboratory_productivity_bonus then
            if need_infix then
                table.insert(notification, { "message.change-infix" })
            end
            table.insert(notification, { "message.change-productivity", player_count_based_settings.productivity })
        end
        force.print(notification)
    end
end

-- refreshes all forces
local function apply_all()
    for _, force in pairs(game.forces) do
        apply(force)
    end
end

-- event registrations
script.on_event(defines.events.on_player_joined_game, function(event)
    apply(game.players[event.player_index].force)
end)

script.on_event(defines.events.on_player_left_game, function(event)
    apply(game.players[event.player_index].force)
end)

script.on_event(defines.events.on_player_changed_force, function(event)
    apply(game.players[event.player_index].force) -- new force
    apply(event.force)                            -- old force
end)

script.on_event(defines.events.on_forces_merged, function(event)
    apply(event.destination)
end)

script.on_event(defines.events.on_research_finished, function(event)
    apply(event.research.force)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function()
    apply_all()
end)

-- command registration
commands.add_command("player_count_based_research_speed_init", "", function()
    apply_all()
end)
