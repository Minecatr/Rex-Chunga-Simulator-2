extends CharacterBody3D

@onready var attraction = preload("res://scenes/attraction.tscn")
@onready var sound = preload("res://sound.tscn")
@onready var uianim = $CanvasLayer/Control/AnimationPlayer

var chunganess = 1
var points = 0

var sf = 0.1
var multi = 1
var speedboost = 0

const SPEED = 6.0
const JUMP_VELOCITY = 12#4.5
const ACCELERATION = 6
const AIR_RESISTANCE = 2
const ANGULAR_ACCELERATION = 6
const WEIGHT = 4

var suffixes = ["Chunga","Chunga","Chungaloo","Chunk","Chonk","Chunker","Chonker","Chungus","Gigachungus","Dodecachungus","Whungus","Zhungus","XXXXL","Quasi-Chunga-Emaculate","nƒinμngus","..Ω","∞"]
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	uianim.play("begin")

func _process(_delta):
	if Input.is_action_just_pressed("shop"):
		if $CanvasLayer/Control/Button.visible:
			uianim.play("open")
		else:
			uianim.play_backwards("open")
	if Input.is_action_pressed("action") && chunganess > 1:
		if $"Poop Timer".is_stopped():
			_on_poop_timer_timeout()
			$"Poop Timer".start()
	elif !$"Poop Timer".is_stopped():
		$"Poop Timer".stop()
		$"Poop Timer".wait_time = 1
		sf = 0.1
	elif !Input.is_action_pressed("action"):
		sf = 0.1

func _physics_process(delta):
	if !is_on_floor():
		velocity.y -= gravity * WEIGHT * delta
	if position.y < -4.9:
		velocity.y = 0.1
	elif position.y < -4.8:
		velocity.y /= 2
	if Input.is_action_pressed("jump") and is_on_floor() || Input.is_action_pressed("jump") and position.y < -4.6:
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, $SpringArm3D.rotation.y).normalized()
	if input_dir || is_on_floor():
		velocity.x = lerp(velocity.x, direction.x * SPEED+speedboost, delta * ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * SPEED+speedboost, delta * ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, direction.x, delta * AIR_RESISTANCE)
		velocity.z = lerp(velocity.z, direction.z, delta * AIR_RESISTANCE)
	
	move_and_slide()
	
	if direction:
		$Character.rotation.y = lerp_angle($Character.rotation.y, deg_to_rad(90) + atan2(direction.x, direction.z), delta * ANGULAR_ACCELERATION)
		$CollisionShape3D.rotation_degrees.y = $Character.rotation_degrees.y

func _on_area_3d_area_entered(area):
	if area.is_in_group("food"):
		var s = sound.instantiate()
		s.stream = load("res://assets/eat.ogg")
		add_child(s)
		resize(chunganess+(area.saturation/10))
		change_points(area.nutrition*multi)
		area.get_parent().queue_free()

func change_points(amount):
	points+=amount
	$CanvasLayer/Control/Label.text = "$"+str(points)

func resize(size):
	chunganess = size
	#for t in get_tree().get_processed_tweens():
	#	t.kill()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3(((size-1)/2)+1,((size-1)/2)+1,((size-1)/2)+1), 1)
	#tween.tween_callback(self.queue_free)
	$CanvasLayer/Control/Label2.text = suffixes[str(round((pow(chunganess,5)))).length()]

func _on_button_pressed():
	uianim.play("open")

func _on_tab_container_tab_changed(_tab):
	$CanvasLayer/Control/TabContainer.current_tab = 0
	uianim.play_backwards("open")


func _on_poop_timer_timeout():
	
	var s = sound.instantiate()
	s.stream = load("res://assets/fart.mp3")
	add_child(s)
	var p = load("res://foodstuffs/poop.tscn").instantiate()
	if $"Poop Timer".wait_time > 0.1:
		$"Poop Timer".wait_time /= 1.2
	if chunganess-sf > 1:
		sf +=.1
	else:
		sf = 0.1
	clamp(sf, 0, chunganess-1)
	p.get_node("Collection").saturation = sf*10
	p.position = $Character/Booty.global_position
	get_parent().add_child(p)
	resize(chunganess-sf)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "begin":
		$CanvasLayer/Control/ColorRect.queue_free()
	else:
		if Input.is_action_pressed("shop"):
			$CanvasLayer/Control/TabContainer/Shop/Speed.grab_focus()

func upgrade(upgradev):
	if points >= upgradev.cost:
		change_points(-upgradev.cost)
		upgradev.value += 1
		upgradev.cost = int(upgradev.costexp*float(upgradev.cost))
		upgradev.text = "Upgrade "+upgradev.name+" - "+str(upgradev.cost)
		if upgradev.name == "Speed":
			speedboost = 2*upgradev.value
		if upgradev.name == "Multi":
			multi = 1 + upgradev.value
		if upgradev.name == "Hotdog Stands":
			get_parent().get_node("HotdogTimer").wait_time = clamp(15.0/(upgradev.value*0.25), 0.05, 10)
		if upgradev.name == "Pizzarias":
			get_parent().get_node("BreadstickTimer").wait_time = clamp(20.0/(upgradev.value*0.25), 0.05, 15)
		if upgradev.name == "KFCs":
			get_parent().get_node("ChickenTimer").wait_time = clamp(25.0/(upgradev.value*0.25), 0.05, 20)
		if upgradev.name == "Magnet":
			$Character/Magnet.visible = true
			$Character/Magnet.monitoring = true
		
		if upgradev.value == upgradev.max:
			upgradev.disabled = true

func _on_magnet_area_entered(area):
	if area.is_in_group("food") && !area.is_in_group("poop"):
		var a = attraction.instantiate()
		area.get_parent().add_child(a)
