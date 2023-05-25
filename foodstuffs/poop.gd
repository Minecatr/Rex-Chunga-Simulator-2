extends Area3D
var saturation :float= 1
var nutrition :int= 0

func _ready():
	for n in get_parent().get_children():
		n.scale = Vector3(sqrt(saturation),sqrt(saturation),sqrt(saturation))
func _on_area_entered(area):
	if area.is_in_group("poop"):
		if area.saturation <= saturation:
			area.monitoring = false
			saturation += area.saturation
			area.get_parent().queue_free()
			for n in get_parent().get_children():
				n.scale = Vector3(sqrt(saturation),sqrt(saturation),sqrt(saturation))
func _process(_delta):
	if get_parent().position.y < -500:
		queue_free()
