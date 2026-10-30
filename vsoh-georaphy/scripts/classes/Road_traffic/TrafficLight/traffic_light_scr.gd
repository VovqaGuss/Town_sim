class_name TrafficLight
extends Node2D

enum Lights {
	RED = 0,
	YELLOW = 1,
	GREEN = 2
}



@export var colizion : CollisionShape2D
## Here s your sprites
@export_category("Visual")
@export_subgroup("lights")
@export var light_sprite : Sprite2D
## Lights Frames from light sprite:
## 0. - Red light
## 1. - Yellow light
## 2. - Green light
@export var LightsFrames = {
	Lights.RED : 0,
	Lights.YELLOW : 0,
	Lights.GREEN : 0, }
## Here s light options
@export_category("Lights")
## Response time:
## 0. - Red light
## 1. - Yellow light
## 2. - Green light
@export var Durations: Dictionary = {
	Lights.RED : 0.0,
	Lights.YELLOW : 0.0,
	Lights.GREEN : 0.0 }


signal signal_light_was_changed(to_what : Lights)

var current_light : Lights = Lights.GREEN :
	set(value) :
		current_light = value
		signal_light_was_changed.emit(value)
var accumulator_time : float = 0.0


func _init() -> void:
	signal_light_was_changed.connect(_on_signal_light_was_changed)

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
	current_light = inpt_light


func _on_signal_light_was_changed(to_light : Lights):
	light_sprite.frame = LightsFrames[to_light]
	if to_light == Lights.RED:
		colizion.disabled = false
	elif to_light == Lights.GREEN:
		colizion.disabled = true
