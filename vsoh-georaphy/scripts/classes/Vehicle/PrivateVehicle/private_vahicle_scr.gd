class_name PrivateVahicle
extends Node2D

@export var starter_point_idx : int = 0 ##Point indx
@export var final_point_idx : int = 0
@export var max_speed : float = 100

var road_network_manager : RoadNetworkManager
var marchrute : Array[int]
var current_target : int

func _ready() -> void:
	_setup_road_manager()
	marchrute = _create_marchrute(starter_point_idx, final_point_idx)
	current_target = marchrute.front()

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

func _create_marchrute(start_idx : int , final_idx : int) -> Array[int]: #Возвращает массив с индексами точек маршрута
	#ТУТ СУКА НЕ БУДЕТ ОБЪЕКТОВ ТОЛЬКО ИНДЕКСЫ!!!!! 😡
	#ИЗУЧИ УЖЕ ДО КОНЦА ЭТОТ КОД БЛЯТЬ!
	# 1. Инициализация
	var visited : Array[int] = []
	var distance = {}
	var parents = {}
	var compiled_marchrute : Array[int] = []
	
	
	
	for i in range(road_network_manager.points.size()):
		distance[i] = INF
	
	
	
	distance[start_idx] = 0
	var current_node : int = start_idx
	
	
	
	if current_node == final_idx:
		push_error("Маршрут не может строится к начальной точке!")
		return []
	
	while current_node != final_idx:
		
		var neigbors : Array[int] = road_network_manager.point_by_indx(current_node).next_points #Индексы соседей текущего узла
		
		for neigbor in neigbors:
			
			var new_dist = distance[current_node] + road_network_manager.point_by_indx(current_node).position.distance_to(road_network_manager.point_by_indx(neigbor).position)
			
			if new_dist < distance[neigbor]:
				distance[neigbor] = new_dist
				parents[neigbor] = current_node
		
		visited.append(current_node)
		
		var min_dist = INF
		var next_node = -1 #ПИЗДА КАКАЯ ВАЖНАЯ ПЕРЕМЕННАЯ
		
		for node_idx in distance:
			
			if node_idx in visited:
				continue
			
			
			if distance[node_idx] < min_dist:
				min_dist = distance[node_idx]
				next_node = node_idx
		
		if next_node == -1:
			print("Путь не найден!")
			break
		
		current_node = next_node
	
	
	
	var curr = final_idx
	
	while curr != start_idx:
		
		compiled_marchrute.append(curr)
		curr = parents[curr]
	
	compiled_marchrute.append(start_idx)
	compiled_marchrute.reverse()
	
	
	
	print("Final march : ", compiled_marchrute)
	GlobalFunc.stack_trace()
	return compiled_marchrute

func _process(delta: float) -> void:
	var velocity = (road_network_manager.point_by_indx(current_target).position - position).normalized() * max_speed
	position += velocity * delta
	
	look_at(road_network_manager.point_by_indx(current_target).position)
	
	if road_network_manager.point_by_indx(current_target).position.distance_to(position) < 3.5:
		current_target = marchrute.pop_front()
