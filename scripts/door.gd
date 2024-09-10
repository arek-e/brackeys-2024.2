class_name Door extends Area2D

enum SpawnDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var destination_level_tag : String
@export var destination_door_tag : String
@export var spawn_direction: SpawnDirection = SpawnDirection.DOWN

@onready var spawn = $Spawn


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
