extends SpringArm3D

@export var mouse_sensitivity := 0.1

func _ready() -> void:
	pass#set_as_top_level(true)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lockcamera") or spring_length == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("lockcamera") and spring_length != 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 90.0)
	
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
func _process(_delta):
		rotation_degrees.y -= Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 90.0)
	
		rotation_degrees.x -= Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
