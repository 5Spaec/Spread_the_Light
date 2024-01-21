extends Node2D

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
