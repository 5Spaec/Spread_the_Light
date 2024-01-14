extends Button

var picked = false
func _pressed():
	if(picked == false):
		print("picked up")
		picked = true
		$"..".reparent($"../../CharacterBody2D/CollisionShape2D/PlayerMove/player")
	elif(picked == true):
		print("put down")
		picked = false
		$"..".reparent($"/root/World")
	pass
