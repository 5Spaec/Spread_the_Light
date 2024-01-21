extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_light(inLight: bool):
	var tween = create_tween()
	if inLight:
		tween.tween_property(self, "volume_db", -10, 2).set_trans(Tween.TRANS_SINE)
	elif not inLight:
		volume_db = -80
		
	pass
