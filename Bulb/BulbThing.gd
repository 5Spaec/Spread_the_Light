
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
@export var darknessAreaShape: CollisionShape2D
var inLight = false
@onready var TXCollision: CollisionShape2D = $CollisionShape2D
@onready var RXCollision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var timer: Timer = Timer.new()
@onready var timer2: Timer = Timer.new()
@onready var triggeredDarkness = false
var picked = false
var moved = false
var playerdialog1 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	light.texture.width = LightRadius
	light.texture.height = LightRadius
	light.enabled = true
	TXCollision.set_disabled(false)
	RXCollision.set_disabled(false)
	timer.one_shot = true
	timer2.one_shot = true
	add_child(timer)
	add_child(timer2)



var screenPan = false
func _on_area_2d_area_entered(area):
	if(playerdialog1 == false) and (area == playerArea):
		dialog()
		playerdialog1 = true
		
	elif(area == treeArea):
		picked = false
		screenPan = true
		deparent()
		dialogBox.set_actor_name("Reginald")
		dialogBox.queue_lines("Thanks for bringing me here. Just one more to go! Please Hurry!")
		self.rotation = 0
		dialogBox.dialog_complete.connect(moveCamToDoor.bind())

func dialog():
	dialogBox.dialog_complete.disconnect(dialog.bind())
	dialogBox.set_actor_name("Reginald")
	dialogBox.queue_lines("Why hello there! My name is Reginald. What do you need from me my child?")
	dialogBox.dialog_complete.connect(dialog1.bind())

func dialog1():
	dialogBox.dialog_complete.disconnect(dialog1.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Oriel said she needed me to take you to the tree room.")
	dialogBox.dialog_complete.connect(dialog2.bind())
func dialog2():
	dialogBox.dialog_complete.disconnect(dialog2.bind())
	dialogBox.set_actor_name("Reginald")
	dialogBox.queue_lines("Well then, we must make haste. Uproot me so that we may continue. ")
	#dialogBox.dialog_complete.connect(dialog2.bind())
func deparent():
	self.reparent($"/root")
	
func moveCamToDoor():
	if(screenPan == true):
		dialogBox.dialog_complete.disconnect(moveCamToDoor.bind())
		var tween = create_tween()
		tween.tween_property(playerCamera, "global_position", doorPoint.global_position, 0.3).set_trans(Tween.TRANS_SINE)
		timer.start(3)
		timer.timeout.connect(resetPlayerCam.bind())
	
func resetPlayerCam():
	var tween = create_tween()
	tween.tween_property(playerCamera, "position", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_SINE)


		
		


func on():
	inLight = true
	TXCollision.set_disabled(false)
	
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
			timer2.start(3)
			timer2.timeout.connect(disableLight.bind())
	elif(picked == true):
		print("put down")
		picked = false
		self.reparent($"/root")

func disableLight():
	var tween = create_tween()
	tween.tween_property(darknessAreaShape, "position", Vector2(-10000, 5000), 6).set_trans(Tween.TRANS_SINE)
	dialogBox.set_actor_name("Ron")
	dialogBox.queue_lines("Oh no the lights went out! Im scared of the Dark...")
