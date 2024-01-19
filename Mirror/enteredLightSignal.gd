extends Node2D

signal entered_light
signal left_light

func _on_polygon_2d_turnoff():
	left_light.emit()


func _on_polygon_2d_turnon():
	entered_light.emit()

