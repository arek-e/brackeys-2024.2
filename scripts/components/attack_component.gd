class_name AttackComponent
extends Node2D

signal has_attacked

func set_collision_enabled(value: bool) -> void:
	emit_signal("has_attacked", value)
