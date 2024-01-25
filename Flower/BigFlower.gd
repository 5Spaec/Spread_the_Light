
extends Area2D

@export var LightRadius = 64
@export var delay = 0
@export var player: Node2D
@export var distance: int = 30
@export var treeArea: Area2D
@export var dialogBox: Control
@export var playerArea: Area2D
@export var playerCamera: Camera2D
@export var doorPoint: Node2D
var inLight = false
var isDisabled = true
@onready var TXCollision: CollisionShape2D = $CollisionShape2D
@onready var RXCollision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
var picked = false
var moved = false
var playerdialog1 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("off")
	light.texture.width = LightRadius
	light.texture.height = LightRadius
	
	call_deferred("start")

func _process(delta):
	pass




var areas = []
func _on_area_2d_area_entered(area):
	if(playerdialog1 == false) and (area == playerArea):
		dialogBox.set_actor_name("Oriel (press/hold space)")
		dialogBox.queue_lines("Thanks for awakening me! Why is it so dark?! I think I know what happened... Click on me to pick me up and go to the door down this hallway.")
		playerdialog1 = true
		
	elif(area == treeArea):
		picked = false
		call_deferred("deparent")
		dialogBox.set_actor_name("Oriel")
		dialogBox.queue_lines("You can put me down here... Just as I thought, my friend here just got tired. Go find my other two friends so we can spread light to this whole place once again!!")
		self.rotation = 0
		dialogBox.dialog_complete.connect(moveCamToDoor.bind())
	elif area != $"." and not isDisabled:
		areas.append(area)
		call_deferred("on")
		Sprite.set_frame(1)
		light.enabled = true

func deparent():
	self.reparent($"/root")
	
func moveCamToDoor():
	var tween = create_tween()
	tween.tween_property(playerCamera, "global_position", doorPoint.global_position, 0.3).set_trans(Tween.TRANS_SINE)
	var timer: Timer = Timer.new()
	add_child(timer)
	dialogBox.dialog_complete.disconnect(moveCamToDoor.bind())
	timer.one_shot = true
	timer.start(3)
	timer.timeout.connect(resetPlayerCam.bind())
	
func resetPlayerCam():
	var tween = create_tween()
	tween.tween_property(playerCamera, "position", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_SINE)

func _on_area_2d_area_exited(area):
	areas.pop_back()
	if(areas.is_empty()) and not moved:
		call_deferred("off")
		Sprite.set_frame(0)
		light.enabled = false
		
		


func on():
	inLight = true
	TXCollision.set_disabled(false)
	
	
	
func off():
	inLight = false
	TXCollision.set_disabled(true)
	
	
func start():
	light.enabled = false
	TXCollision.set_disabled(true)
	RXCollision.set_disabled(false)
	isDisabled = false
	
signal interacting
func _on_big_plant_detect_pressed():
	print("clicked")
	if(picked == false):
		print("trying pick up")
		var playerPos: Vector2 = player.global_position
		var box: Vector2 = self.global_position
		if(sqrt(abs((box[0] - playerPos[0]) * (box[0] - playerPos[0]) + (box[1] - playerPos[1]) * (box[1] - playerPos[1]))) < distance):
			print("picked up")
			picked = true
			moved = true
			self.reparent(player)
			interacting.emit(true)
	elif(picked == true):
		print("put down")
		picked = false
		self.reparent($"/root")
		interacting.emit(false)
		
