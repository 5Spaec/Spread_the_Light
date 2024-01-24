extends Node2D

@export var camera: Camera2D
signal isLight
var areaEntered = []
func _on_area_2d_area_entered(area):
	areaEntered.append(area)
	isLight.emit(true)
	$AnimatedSprite2D.set_frame(1)
		


func _on_area_2d_area_exited(area):
	areaEntered.pop_back()
	if(areaEntered.is_empty()):
		isLight.emit(false)
		$AnimatedSprite2D.set_frame(0)

signal isButtonOn
var isOn = false
func _on_mirror_click_detect_pressed():
	var playerPos: Vector2 = camera.global_position
	var box: Vector2 = self.global_position
	if(sqrt(abs((box[0] - playerPos[0]) * (box[0] - playerPos[0]) + (box[1] - playerPos[1]) * (box[1] - playerPos[1]))) < 30):
		isButtonOn.emit(isOn)
		isOn = not isOn
	pass
