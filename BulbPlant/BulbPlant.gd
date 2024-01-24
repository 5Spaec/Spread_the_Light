
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
	light.texture.width = LightRadius
	light.texture.height = LightRadius
	Sprite.set_frame(1)
	light.enabled = true
	call_deferred("on")




var areas = []
func _on_area_2d_area_entered(area):
	if(playerdialog1 == false) and (area == playerArea):
		dialogBox.set_actor_name("Jimbob The Great (press/hold space)")
		dialogBox.queue_lines("You say Oriel Sent You!!! We Must Hurry")
		playerdialog1 = true
		
	elif(area == treeArea):
		picked = false
		self.rotation = 0
		call_deferred("deparent")
		dialogBox.set_actor_name("Jimbob The Great")
		dialogBox.queue_lines("Unhand me Peasant! Hello dear Oriel, I see that our friend is asleep... Please go find our third friend so we can wake this big guy up!! *thinks* ~~Finally some alone time with Oriel!! hehe~~")
		dialogBox.dialog_complete.connect(moveCamToDoor.bind())


func deparent():
	self.reparent($"/root")
	
func moveCamToDoor():
	var tween = create_tween()
	tween.tween_property(playerCamera, "position", to_local(doorPoint.global_position), 0.3).set_trans(Tween.TRANS_SINE)
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(3)
	timer.timeout.connect(resetPlayerCam.bind())
	
func resetPlayerCam():
	var tween = create_tween()
	tween.tween_property(playerCamera, "position", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_SINE)

		
		


func on():
	inLight = true
	TXCollision.set_disabled(false)
	
	
	
	
func start():
	light.enabled = false
	TXCollision.set_disabled(true)
	RXCollision.set_disabled(false)
	isDisabled = false
	

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
	elif(picked == true):
		print("put down")
		picked = false
		self.reparent($"/root")

