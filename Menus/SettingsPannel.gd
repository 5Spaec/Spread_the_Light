extends Control



func _on_h_slider_value_changed(value):
	$Panel/HSlider/VolumeAmount.text = str(value)
	pass
