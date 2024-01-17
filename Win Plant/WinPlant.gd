extends Area2D

signal plantOn
signal plantOff
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _ready():
	pass # Replace with function body.


var lights = []
func _on_area_entered(area):
	lights.append(area)
	plantOn.emit()
	sprite.set_frame(1)
	pass # Replace with function body.


func _on_area_exited(area):
	lights.pop_back()
	if(lights.is_empty()):
		sprite.set_frame(0)
		plantOff.emit()
	pass # Replace with function body.
