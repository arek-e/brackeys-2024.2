extends Node2D


@onready var canvas_layer = $CanvasLayer
@onready var ui = $CanvasLayer/DayAndNightCycleUI
@onready var canvas_modulate = $CanvasModulate


func _ready():
	canvas_layer.visible = true
	canvas_modulate.time_tick.connect(ui.set_daytime)
