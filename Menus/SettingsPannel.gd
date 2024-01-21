extends Control



func _on_h_slider_value_changed(value):
	$Panel/HSlider/VolumeAmount.text = str(value)
	AudioServer.set_bus_volume_db(0, value)
	pass


func _on_exit_game_button_pressed():
	get_tree().quit()
