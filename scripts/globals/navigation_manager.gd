extends Node

const scene_bunker = preload("res://scenes/levels/bunker.tscn")
const scene_outside = preload("res://scenes/levels/outside.tscn")

signal on_trigger_player_spawn(position: Vector2, direction: int)

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"bunker":
			scene_to_load = scene_bunker
		"outside":
			scene_to_load = scene_outside
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		TransitionScreen.transition()
		await TransitionScreen.on_animation_finished

		#get_tree().change_scene_to_packed(scene_to_load)
		get_tree().call_deferred("change_scene_to_packed", scene_to_load)

func trigger_player_spawn(position: Vector2, direction: int):
	on_trigger_player_spawn.emit(position, direction)
