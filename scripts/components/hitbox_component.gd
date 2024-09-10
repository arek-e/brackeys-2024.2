class_name HitboxComponent
extends Area2D

@export var health_component : HealthComponent
@onready var animation_tree: AnimationTree = $"../AnimationTree"

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		if animation_tree:
			animation_tree["parameters/conditions/is_hit"] = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		if animation_tree:
			animation_tree["parameters/conditions/is_hit"] = false
	
