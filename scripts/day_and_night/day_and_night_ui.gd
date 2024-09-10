class_name DayAndNightCycleUI extends Control

@onready var day_label: Label = %DayLabel
@onready var time_label: Label = %TimeLabel

func set_daytime(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day + 1)
	
	# Set time label in 24-hour format
	time_label.text = str(hour).pad_zeros(2) + ":" + _minute(minute)


func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute)
	return str(minute)


func _remap_rangef(input:float, minInput:float, maxInput:float, minOutput:float, maxOutput:float):
	return float(input - minInput) / float(maxInput - minInput) * float(maxOutput - minOutput) + minOutput
