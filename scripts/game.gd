extends Node

var on_cutscene: bool = false ## is the player in a cutscene?
var on_quest_menu: bool = false ## is the player viewing the quest list?
var on_game_menu: bool = false ## is the player in the "esc" menu?
var on_transition: bool = false ## is the player in a active transition?

var player_can_control: bool: ## can the player move?
	get:
		return not on_cutscene and not on_quest_menu and not on_game_menu and not on_transition
