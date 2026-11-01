extends Node2D

@onready var parent : Node2D = get_parent()
@onready var raycasts = {
	"Left" : $RayCast2D3,
	"Center" : $RayCast2D2,
	"Right" : $RayCast2D
}

func once_of_rays_colliding() -> bool:
	var colliding : bool = false
	for raycast in raycasts: 
		if raycasts[raycast].is_colliding():
			colliding = true
	
	return colliding

func get_nearest_distance() -> float:
	var pos = parent.position
	var min_distance = INF
	for ray in raycasts: 
		if (pos.distance_to(raycasts[ray].get_collision_point()) < min_distance
			and once_of_rays_colliding()):
			
			min_distance = pos.distance_to(raycasts[ray].get_collision_point())
	
	return min_distance
