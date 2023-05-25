extends Area3D
@export var saturation :float= 1
@export var nutrition :int= 1

func _on_despawn_timer_timeout():
	get_parent().queue_free()
