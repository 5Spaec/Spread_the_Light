
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
		dialogBox.set_actor_name("Ron (press/hold space)")
		dialogBox.queue_lines("Orial Called for MEEEE!?! Oh my gosh, This is my big DAY!")
		playerdialog1 = true
		
	elif(area == treeArea):
		picked = false
		screenPan = true
		deparent()
		dialogBox.set_actor_name("Ron")
		dialogBox.queue_lines("HI ORIEL!! *Ahem* hello, I see that the light giving tree has gone back to sleep, go get my brother ronny and we can wake this guy up again! *Thinks* ~~Finally some alone time with Oriel~~")
		self.rotation = 0
		dialogBox.dialog_complete.connect(moveCamToDoor.bind())

func deparent():
	self.reparent($"/root")
	
func moveCamToDoor():
	if(screenPan == true):
		var tween = create_tween()
		tween.tween_property(playerCamera, "global_position", doorPoint.global_position, 0.3).set_trans(Tween.TRANS_SINE)
		timer.start(3)
		timer.timeout.connect(resetPlayerCam.bind())
		dialogBox.dialog_complete.disconnect(moveCamToDoor.bind())
	
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
