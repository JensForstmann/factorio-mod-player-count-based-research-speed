-- returns the reasearched laboratory_speed_modifier for this forced
local function get_researched_speed_modifier (force)
    local researched_speed_modifer = 0
    for _, tech in pairs(force.technologies) do
        if tech.upgrade and tech.researched and tech.valid and tech.enabled then
            for _, mod in pairs(tech.effects) do
                if mod.type == "laboratory-speed" then
                    researched_speed_modifer = researched_speed_modifer + mod.modifier
                end
            end
        end
    end
    return researched_speed_modifer
end

-- returns the player count based modifier defined in the settings
local function get_player_modifier(player_count)
    local setting = settings.global["for-" .. player_count .. "-player"]
    if setting == nil then
        setting = settings.global["for-more-player"]
    end
    return setting.value
end

-- refreshes the laboratory_speed_modifier for this force
-- prints a message if it is changed
local function apply(force)
    local researched_speed_modifer = get_researched_speed_modifier(force)
    local player_count = #force.connected_players
    local player_modifier = get_player_modifier(player_count)
    local new_laboratory_speed_modifier = (1 + researched_speed_modifer) * player_modifier - 1
    if new_laboratory_speed_modifier ~= force.laboratory_speed_modifier then
        force.print{"message.change",
            "[font=default-bold]" .. force.laboratory_speed_modifier .. "[/font]",
            "[font=default-bold]" .. new_laboratory_speed_modifier .. "[/font]"}
        force.laboratory_speed_modifier = new_laboratory_speed_modifier
    end
end

-- refreshes all forces' laboratory_speed_modifier
local function apply_all()
    for _, force in pairs(game.forces) do
        apply(force)
    end
end

-- event registrations
script.on_event(defines.events.on_player_joined_game, function (event)
    apply(game.players[event.player_index].force)
end)

script.on_event(defines.events.on_player_left_game, function (event)
    apply(game.players[event.player_index].force)
end)

script.on_event(defines.events.on_player_changed_force, function (event)
    apply(game.players[event.player_index].force) -- new force
    apply(event.force) -- old force
end)

script.on_event(defines.events.on_forces_merged, function (event)
    apply(event.destination)
end)

script.on_event(defines.events.on_research_finished, function (event)
    apply(event.research.force)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function ()
    apply_all()
end)
