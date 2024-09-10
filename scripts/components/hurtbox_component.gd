class_name HurtboxComponent
extends Area2D

signal hit_enemy

@onready var tool: Tool = get_parent()

func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	if area is HitboxComponent:
		var attack := Attack.new()

		attack.damage = tool.attack_damage
		attack.knockback = 150.0

		area.damage(attack)
		area.knockback(tool.global_position, attack)

		hit_enemy.emit()
