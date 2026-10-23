@tool
class_name TravelPoint
extends Resource

@export var name : String = "TravelNode"
@export var position : Vector2 :
	set(value):
		position = value
		
		emit_changed()
@export var next_points : Array[int] ##Индексы следующих точек
