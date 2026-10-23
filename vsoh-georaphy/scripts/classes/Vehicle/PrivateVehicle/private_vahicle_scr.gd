class_name PrivateVahicle
extends Node2D

@export var starter_point_idx : int = 0 ##Point indx
@export var final_point_idx : int = 0
@export var max_speed : float = 100

var road_network_manager : RoadNetworkManager
var marchrute : Array[int]

func _ready() -> void:
	_setup_road_manager()
	_create_marchrute(starter_point_idx, final_point_idx)

func _setup_road_manager() -> void:
	road_network_manager = get_parent().get_tree().get_first_node_in_group("RoadManager")
	
	#Проверка есть ли вообще этот узел
	if !road_network_manager:
		push_error(str(self), "Dont find a Road Manager!")
		return
	
	#Проверка не выходит ли starter_point_idx за пределы массива points
	if starter_point_idx < 0 or starter_point_idx >= road_network_manager.points.size():
		push_error(name, ": Starter point index ", starter_point_idx, " is out of bounds! Total points : ", road_network_manager.points.size())
		return
	
	var point = road_network_manager.points[starter_point_idx]
	
	#current_point = point
	print_rich("[b][color=green]", self.name, "	: Road manager was founded! And point was successfully getted![/color][/b]")

func _create_marchrute(start_idx : int , final_idx : int): #Возвращает массив с индексами точек маршрута
	# 1. Инициализация
	var visited: Array[int] = []
	var distance = {}
	
	for i in range(road_network_manager.points.size()): #Заполняем массив бесконечностями
		distance[i] = INF
	
	print(distance)
	
	var current_node: int = start_idx
	
	var neighbors = road_network_manager.point_by_indx(current_node).next_points #Получеам соседей текущей ноды
	print(neighbors)
	
	
