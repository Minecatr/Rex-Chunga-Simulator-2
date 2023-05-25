extends Control

func _process(_delta):
	if Input.is_action_just_pressed("jump") && $AnimationPlayer.is_playing():
		_on_animation_player_animation_finished("begin")
	if Input.is_action_just_pressed("ui_accept") && !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("begin")

func _on_button_pressed():
	$AnimationPlayer.play("begin")


func _on_animation_player_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://world.tscn")
