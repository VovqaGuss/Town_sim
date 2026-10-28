class_name PrivateVehicle
extends Node2D

@export var starter_point_idx : int = 0 ##Point indx
@export var final_point_idx : int = 0
@export var max_speed : float = 100.0 ## max 200
@export var mass : float = 5.5
@onready var ray_cast = $RayCasts/ObstacleAhead

var max_force : float = 15
var max_velocity : float = 150
var brake_radius : float = 200

var velocity : Vector2
var desired_velocity : Vector2
var steering : Vector2

var road_network_manager : RoadNetworkManager
var marchrute : Array[int]
var current_target : int
#signal vehicle_was_arrived

func _ready() -> void:
	_setup_road_manager()
	marchrute = _create_marchrute(starter_point_idx, final_point_idx)
	current_target = marchrute.pop_front()
	position = road_network_manager.point_by_indx(current_target).position


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
	var i : int = 0
	
	print(parents)
	
	while curr != start_idx:
		compiled_marchrute.append(curr)
		curr = parents[curr] #parents уже заполнен самыми близкими соседями всех точек
	
	compiled_marchrute.append(start_idx)
	compiled_marchrute.reverse()
	
	
	
	print("Final march : ", compiled_marchrute)
	GlobalFunc.stack_trace()
	return compiled_marchrute


func _process(delta: float) -> void:
	var distance = road_network_manager.point_by_indx(current_target).position.distance_to(position)
	
	if distance < 25.0 && !marchrute.is_empty(): #px
		current_target = marchrute.pop_front()
	
	
	if velocity.length() > 0.1:
		rotation = velocity.angle()
	
	
	position += velocity * delta
	_seek(95.0)


func _seek(showingRadius : float) -> void:
	desired_velocity = (road_network_manager.point_by_indx(current_target).position - position)
	var distance = desired_velocity.length()
	
	var current_speed_limit = max_velocity
	
	if ray_cast.is_colliding():
		var hit_point = ray_cast.get_collision_point()
		var distance_to_obstacle = position.distance_to(hit_point)
		
		if distance_to_obstacle < brake_radius:
			current_speed_limit = min(current_speed_limit, max_velocity * (distance_to_obstacle / brake_radius))
		
		if distance_to_obstacle <  brake_radius / 3:
			current_speed_limit = 0.0
	
	
	if distance < showingRadius && current_target == final_point_idx:
		current_speed_limit = min(current_speed_limit, max_velocity * (distance / showingRadius))
	
	if distance > 0.1:
		desired_velocity = desired_velocity.normalized() * current_speed_limit
	
	else:
		desired_velocity = Vector2.ZERO
	
	steering = desired_velocity - velocity
	steering = steering.limit_length(max_force)
	steering = steering / mass
	
	velocity = (velocity + steering).limit_length(max_speed)
