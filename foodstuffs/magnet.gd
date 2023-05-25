extends RigidBody3D


func _integrate_forces(state):
	var target_position = get_parent().get_node("Player").position
	look_follow(state, global_transform, target_position)
	apply_torque(-5 * global_transform.basis.z)

func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis * Vector3(0, 0, 1)
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	state.angular_velocity = up_dir * (rotation_angle / state.step)
