@tool

extends Node2D

@export var tool : ToolResource

@onready var tool_sprite : Sprite2D = %ToolSprite

func _ready() -> void:
	print_debug("READY")
	load_tool()
	
func _process(delta: float) -> void:
	pass


func load_tool() -> void:
	if tool:
		tool_sprite.texture = tool.sprite
		tool_sprite.scale = tool.sprite_scale
		tool_sprite.position = tool.sprite_position
