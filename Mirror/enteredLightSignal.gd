extends Node2D

signal entered_light
signal left_light


func _on_mirror_detect_2_area_entered(_area):
	entered_light.emit()
	print("sentSignal1")



func _on_mirror_light_beam_2_turnoff():
	left_light.emit()
	print("sentSignal2")
