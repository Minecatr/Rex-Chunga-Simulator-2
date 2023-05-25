extends Button

@export var cost : int = 5
@export var costexp : float = 1.25
@export var max : int = 0
var value = 0

func _pressed():
	get_parent().get_parent().get_parent().get_parent().get_parent().upgrade(self)
