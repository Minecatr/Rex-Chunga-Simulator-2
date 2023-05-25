extends RigidBody3D

func _physics_process(_delta):
	if position.y < -4.5:
		linear_velocity.y = 1
	elif position.y < -4.6:
		linear_velocity.y /= 20
