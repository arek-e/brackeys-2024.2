class_name Level extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
		
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	print_debug(door.get_path())
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
