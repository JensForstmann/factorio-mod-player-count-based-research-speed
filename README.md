# factorio-mod-player-count-based-research-speed
 
[Factorio Mod Portal](https://mods.factorio.com/mod/player-count-based-research-speed)

## description

This mod dynamically adjusts the research speed and productivity based on the current count of online players. It allows to slow down or even stop the research in case none or only a few players are online.

The speed and productivity multiplier is configurable for 0, 1, 2, 3, 4 and 5+ players.

## calculation

A setting of 1 will not change the speed, a setting of 0 will always disable the research. 

The configured setting will applied multiplicative after the ingame bonus for research speed.

Example: If you have researched all [lab research speed](https://wiki.factorio.com/Lab_research_speed_(research)), the lab would normally display "3.5 (+250%)". If the current multiplier would be 0.5 your lab speed would become "1.75 (+75%)".

## productivity multiplier

In vanilla there is no productivity bonus research. Having a productivity multiplier of 1 will not change it. But if you want to grant a bonus when more players are online you can set it to 1.1 (resulting in +10% productivity).

When using other mods which adds research to give you productivity bonus this multiplier will apply after the researched effect.

Example: If you have +20% productivity but having a productivity multiplier of 0.9 this would result in +8% productivity. (1.2 * 0.9 = 1.08)

## screenshots

settings

![screenshot of settings](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/settings.png)

several ingame notification examples

![screenshot of notofocation](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/notification.png)

example lab with slow speed

![screenshot of lab](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/lab.png)

example lab with productivity bonus

![screenshot of lab](https://raw.githubusercontent.com/JensForstmann/factorio-mod-player-count-based-research-speed/master/gallery/lab2.png)

## uninstalling

Because this mod changes the force's laboratory_speed_modifier and laboratory_productivity_bonus you must go into the mod settings and disable both "enable" checkboxes. This will apply multipliers of 1 (basically reset the values to their correct values based on the current research).

If you already removed the mod and don't want to install it again for proper uninstalling (and do not care about achievements being disabled) you can run the following command:

`/c game.player.force.reset_technology_effects()`
