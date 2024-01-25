extends Control



func _on_h_slider_value_changed(value):
	$Panel/HSlider/VolumeAmount.text = str(value)
	AudioServer.set_bus_volume_db(0, value)
	pass


func _on_exit_game_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
