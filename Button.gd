extends Button

var picked = false
func _pressed():
	
	if(picked == false):
		var player: Vector2 = $"../../CharacterBody2D/CollisionShape2D/PlayerMove".position
		var box: Vector2 = $"..".position
		if(sqrt(abs((box[0] - player[0]) * (box[0] - player[0]) + (box[1] - player[1]) * (box[1] - player[1]))) < 150):
			print("picked up")
			picked = true
			$"..".reparent($"../../CharacterBody2D/CollisionShape2D/PlayerMove/player")
	elif(picked == true):
		print("put down")
		picked = false
		$"..".reparent($"/root/World")
	pass
