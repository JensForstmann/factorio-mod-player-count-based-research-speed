# factorio-mod-player-count-based-research-speed
 
[Factorio Mod Portal](https://mods.factorio.com/mod/player-count-based-research-speed)

## description

This mod dynamically adjusts the research speed based on the current count of online players. It allows to slow down or even stop the research in case none or only a few players are online.

The speed multiplier is configurable for 0, 1, 2, 3, 4 and 5+ players.

## calculation

A setting of 1 will not change the speed, a setting of 0 will always disable the research. 

The configured setting will applied multiplicative after the ingame bonus for research speed.

Example: If you have researched all [lab research speed](https://wiki.factorio.com/Lab_research_speed_(research)), the lab would normally display "3.5 (+250%)". If the current multiplier would be 0.5 your lab speed would become "1.75 (+75%)".

## screenshots

settings

![screenshot of settings](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/settings.png)

ingame notification

![screenshot of notofocation](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/notification.png)

example lab with speed 0

![screenshot of lab](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/lab.png)

## uninstalling

Because this mod changes the force's laboratory_speed_modifier you must set all multiplier in the settings to 1 prior uninstalling. This will apply the normal settings again. After that you can remove the mod.

If you already removed the mod and forget to do that, you can also set laboratory_speed_modifier to the "cumulative effect" based on your current research, see table [in the wiki](https://wiki.factorio.com/Lab_research_speed_(research)) (140% would become 1.4, 20% -> 0.2, 0% -> 0, ...)

`/c game.player.force.laboratory_speed_modifier = 1.4`
