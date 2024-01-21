extends AnimatedSprite2D

var inLight = false
var active = false
@export var player: Node2D
@export var distance: int = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_frame(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(inLight == true and active == true):
		var mousePos: float = rad_to_deg(get_angle_to(get_global_mouse_position()) + PI)
		# this is a value used to calculate how much to deviate from the corner angles (45, 135, 225, 315)
		var cornerBounds = 10
		var corner1 = 45
		var corner2 = 135
		var corner3 = 225
		var corner4 = 315

		if((mousePos >= corner1 - cornerBounds) and (mousePos < corner1 + cornerBounds)):
			self.set_frame(2)
		elif((mousePos >= corner1 + cornerBounds) and (mousePos < corner2 - cornerBounds)):
			self.set_frame(3)
		elif((mousePos >= corner2 - cornerBounds) and (mousePos < corner2 + cornerBounds)):
			self.set_frame(4)
		elif((mousePos >= corner2 + cornerBounds) and (mousePos < corner3 - cornerBounds)):
			self.set_frame(5)
		elif((mousePos >= corner3 - cornerBounds) and (mousePos < corner3 + cornerBounds)):
			self.set_frame(6)
		elif((mousePos >= corner3 + cornerBounds) and (mousePos < corner4 - cornerBounds)):
			self.set_frame(7)
		elif((mousePos >= corner4 - cornerBounds) and (mousePos < corner4 + cornerBounds)):
			self.set_frame(8)
		elif((mousePos >= corner4 + cornerBounds) or (mousePos < corner1 - cornerBounds)):
			self.set_frame(1)
		$LightBeam.rotation = deg_to_rad(mousePos) - (PI/2)
		print(mousePos)
	pass


func _on_light_beam_entered_light():
	inLight = true
	self.set_frame(3)


func _on_light_beam_left_light():
	inLight = false
	self.set_frame(0)

signal interacting
func _input(event):
	if event is InputEventMouseButton:
		if(active == true):
			active = not active
			interacting.emit(false)
			


func _on_spinny_click_detect_pressed():
	var playerPos: Vector2 = player.global_position
	var box: Vector2 = self.global_position
	if(sqrt(abs((box[0] - playerPos[0]) * (box[0] - playerPos[0]) + (box[1] - playerPos[1]) * (box[1] - playerPos[1]))) < distance):
		active = not active
		interacting.emit(true)
	pass
