extends Resource
class_name ToolResource

@export var name: String
@export var icon: Texture
@export var description: String
@export var cost: int

# FUTURE: In godot 4.4 typed dictionaries will be supported
#@export var tool_attributes: Dictionary[String, ToolSpriteAttributes] = {}
@export var tool_sprite_attributes: Array[ToolSpriteAttributes] = []