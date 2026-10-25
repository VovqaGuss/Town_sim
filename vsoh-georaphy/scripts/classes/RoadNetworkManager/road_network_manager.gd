@tool
class_name RoadNetworkManager
extends Node2D

@export_subgroup("PointManager")
@export_tool_button("Create new point", "CurveCreate") var create_new_point_button = _create_point
@export_tool_button("Get all connections (for developers)", "AnimationTrackList") var get_all_connections_button = _get_all_connections
@export var debug : bool = false
@export var points : Array[TravelPoint] = [] :
	set(value):
		points = value
		queue_redraw()

func _ready() -> void:
	_update_listener()
	queue_redraw()

func _get_all_connections() -> void:
	for res in points:
		printt(res.name, "successfully connected! to :", res.changed.get_connections())
	if points.is_empty():
		push_error("Points not found!")

func get_weight_of_edge_by_indxs(p_idx_from : int, p_idx_to : int) -> float :
	
	if (p_idx_from < 0 or p_idx_from > points.size() or 
		p_idx_to == p_idx_from or 
		p_idx_to < 0 or p_idx_to > points.size()):
			
			push_error("Get_weight_of_edge out of bounds!!!")
			return 0.0
	
	else:
		return points[p_idx_from].position.distance_to(points[p_idx_to].position)

func point_by_indx(indx : int) -> TravelPoint:
	return points[indx]

func _create_point() -> void:
	if Engine.is_editor_hint():
		
		var res = TravelPoint.new()
		res.name = "Point " + str(points.size())
		res.next_points.append(points.size() + 1)
		
		points.append(res)
		
		notify_property_list_changed()
		_update_listener()
		queue_redraw()

func _update_listener() -> void:
	for res in points:
		if res && !res.changed.is_connected(_on_point_was_moved):
			res.changed.connect(_on_point_was_moved)

func _on_point_was_moved() -> void:
	print("point was moved!")
	queue_redraw()
	
	if Engine.is_editor_hint():
		get_tree().edited_scene_root.queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint() or debug == true:
		
		for point in points:
			if point:
				draw_string(ThemeDB.fallback_font, point.position , point.name, HORIZONTAL_ALIGNMENT_CENTER, -1, ThemeDB.fallback_font_size)
				draw_circle(point.position, 2.5, Color.WHITE)
			
		
		for i in range(points.size()):
			var current_point = points[i]
			
			if !current_point : 
				continue
				queue_redraw()
			
			for target_idx in current_point.next_points:
				
				if target_idx >= 0 && target_idx < points.size():
					var target_point = points[target_idx]
						
					if target_point:
						draw_line(current_point.position, target_point.position, Color.WHITE, 1.2)
