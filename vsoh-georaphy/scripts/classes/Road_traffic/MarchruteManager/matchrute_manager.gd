class_name MarchruteManager
extends Node

const SECOND = 60
const MINUTE = 60
const HOUR = 24

enum Units_of_time {
	Hour, # 0
	Minute,# 1
	Second # 2
}


## 0 - sec
## 1 - min
## 2 - hours
var time = {
	Units_of_time.Hour : 0,
	Units_of_time.Minute : 0,
	Units_of_time.Second : 0
}

@export var debug : bool = false

signal clock_was_chagned(clock : Array[int])

var miliseconds = 0
var limits = [SECOND, MINUTE, HOUR]

func _process(delta: float) -> void:
	miliseconds += delta
	
	if miliseconds >= 1.0:
		miliseconds -= 1.0
		
		_clock()

func _clock() -> void:
	
	time[0] += 1
	
	for i in range(time.size() - 1):
		
		if time[i] >= limits[i]:
			
			time[i] = 0
			time[i + 1] += 1
	
	if time[time.size() - 1] > limits[limits.size() - 1]:
		time[time.size() - 1] = 0
	
	clock_was_chagned.emit(time)
	
	if debug:
		printt("Time :",
			"Seconds : ", time.get(0),
			"Minute : ", time.get(1),
			"Hour : ", time.get(2)
		)
