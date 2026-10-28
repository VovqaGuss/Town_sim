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

const SECOND = 60
const MINUTE = 60
var seconds = 0
var num = 0

func _process(delta: float) -> void:
	num += 1
	if num == SECOND:
		print("Second!")
		seconds += 1
		num = 0
	
	if seconds == MINUTE:
		print("Minute!")
		seconds = 0

func _change_light(inpt_light : Lights) -> void:
	
	signal_light_was_chaged.emit()
	current_light = inpt_light
