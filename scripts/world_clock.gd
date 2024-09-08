extends Node

var time_accumulator = 0
var hour = 0
var minute = 0
var is_paused = false

func get_time_as_formatted_string():
	return ("0" + str(hour) if hour < 10 else str(hour)) + ":" + ("0" + str(minute) if minute < 10 else str(minute))

func increase_clock(_increase_hours, _increase_minutes):
	minute += _increase_minutes
	hour += _increase_hours + minute / 60
	hour = hour % 24
	minute = minute % 60

func _init():
	increase_clock(6, 0)

func _process(delta):
	if (is_paused): return
	time_accumulator += delta
	
	if time_accumulator >= 1.0:  # 1 second has passed
		time_accumulator = 0
		increase_clock(0, 1)  # Increment by 1 minute
	$world_clock_label.text = get_time_as_formatted_string()
