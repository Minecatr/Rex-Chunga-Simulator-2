extends Node3D

@onready var hotdog = preload("res://foodstuffs/hotdog.tscn")
@onready var breadstick = preload("res://foodstuffs/breadstick.tscn")
@onready var chicken = preload("res://foodstuffs/chicken.tscn")
func _ready():
	randomize()
func _on_timer_timeout():
	for s in $Spawns/hotdog.get_children():
		var fc = hotdog.instantiate()
		fc.position = s.get_node("Spawn").global_position
		fc.rotation = s.rotation
		add_child(fc)


func _on_breadstick_timer_timeout():
	for s in $Spawns/breadstick.get_children():
		var fc = breadstick.instantiate()
		fc.position = s.get_node("Spawn").global_position
		fc.rotation = s.rotation
		add_child(fc)


func _on_chicken_timer_timeout():
	for s in $Spawns/chicken.get_children():
		var fc = chicken.instantiate()
		fc.position = s.get_node("Spawn").global_position
		fc.rotation = s.rotation
		add_child(fc)
