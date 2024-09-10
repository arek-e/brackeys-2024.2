extends Resource
class_name ToolResource

enum AttackType {
	SWING
}

@export var name: String
@export var description: String
@export var damage_amount: float
@export var attack_type: AttackType


@export_category("Visual Settings")
@export var icon: Texture
@export var sprite: Texture2D
@export var sprite_scale: Vector2 = Vector2(1,1)
@export var sprite_position: Vector2 = Vector2(0,0)

# FUTURE: In godot 4.4 typed dictionaries will be supported
#@export var tool_attributes: Dictionary[String, ToolSpriteAttributes] = {}
@export var tool_sprite_attributes: Array[ToolSpriteAttributes] = []
