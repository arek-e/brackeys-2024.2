@tool

class_name Tool extends Node2D

@export var TOOL_RESOURCE: ToolResource

@onready var attack_component: AttackComponent = get_parent().get_node("AttackComponent")
@onready var tool_sprite: Sprite2D = %ToolSprite
@onready var hurt_box_component: HurtboxComponent = $HurtboxComponent

var attack_damage: int


func _ready() -> void:
	load_tool()
	if attack_component:
		attack_component.connect("has_attacked", _on_attack)

	
func _on_attack(collision_enabled: bool) -> void:
	hurt_box_component.get_node("CollisionShape2D").disabled = not collision_enabled


func load_tool() -> void:
	if TOOL_RESOURCE:
		tool_sprite.texture = TOOL_RESOURCE.sprite
		tool_sprite.scale = TOOL_RESOURCE.sprite_scale
		tool_sprite.position = TOOL_RESOURCE.sprite_position
		print_debug(TOOL_RESOURCE.damage_amount)
		attack_damage = TOOL_RESOURCE.damage_amount
