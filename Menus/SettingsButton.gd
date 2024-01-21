extends Control

@export var pannel: Control
var pannelOn = false

func _on_texture_button_pressed():
	if pannelOn == false:
		pannel.visible = true
		pannelOn = true
	else:
		pannel.visible = false
		pannelOn = false
	pass 
