extends RigidBody2D

@export var player: Node2D
@export var distance: int = 30
var picked = false

func _on_mirror_click_detect_pressed():
	print("clicked")
	if(picked == false):
		print("trying pick up")
		var playerPos: Vector2 = player.global_position
		var box: Vector2 = self.global_position
		if(sqrt(abs((box[0] - playerPos[0]) * (box[0] - playerPos[0]) + (box[1] - playerPos[1]) * (box[1] - playerPos[1]))) < distance):
			print("picked up")
			picked = true
			self.reparent(player)
			self.freeze = true
	elif(picked == true):
		print("put down")
		picked = false
		self.reparent($"/root")
		self.freeze = false
	pass
	

