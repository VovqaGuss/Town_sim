class_name TrafficLight
extends Node2D

enum Lights {
	RED,
	YELLOW,
	GREEN
}

## Here s light options
@export_category("Lights")

## Response time:
## 0. - Red light
## 1. - Yellow light
## 2. - Green light
@export var Durations: Dictionary = {
	Lights.RED : 0.0,
	Lights.YELLOW : 0.0,
	Lights.GREEN : 0.0
}

signal light_signal_change_req
signal signal_light_was_chaged

var current_light : Lights = Lights.RED

var accumulator_time : float = 0.0

func _process(delta: float) -> void:
	accumulator_time += delta
	
	if accumulator_time > Durations[current_light]:
		accumulator_time = 0.0
		_to_next_light()

func _to_next_light() -> void:
	match current_light:
		Lights.RED: _change_light(Lights.YELLOW)
		Lights.YELLOW: _change_light(Lights.GREEN)
		Lights.GREEN : _change_light(Lights.RED)

func _change_light(inpt_light : Lights) -> void:
	
	signal_light_was_chaged.emit()
	current_light = inpt_light
