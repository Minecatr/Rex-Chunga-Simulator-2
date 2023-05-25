extends Node

func _physics_process(_delta):
	var target = get_parent().get_parent().get_node("Player").get_node("Character").get_node("Magnet").get_node("Mag").global_position
	get_parent().look_at(target)
	get_parent().linear_velocity = -get_parent().position.distance_to(target)*get_parent().global_transform.basis.z
	#get_parent().angular_velocity = get_parent().position-get_parent().get_parent().get_node("Player").position
