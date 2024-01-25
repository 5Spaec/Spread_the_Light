
extends Area2D

@export var LightRadius = 64
@export var delay = 0
@export var player: Node2D
@export var distance: int = 30
@export var treeArea: Area2D
@export var dialogBox: Control
@export var playerArea: Area2D
@export var playerCamera: Camera2D
var inLight = false
@onready var TXCollision: CollisionShape2D = $CollisionShape2D
@onready var RXCollision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var timer: Timer = Timer.new()
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
	add_child(timer)



var screenPan = false
func _on_area_2d_area_entered(area):
	if(playerdialog1 == false) and (area == playerArea):
		dialogBox.set_actor_name("Ronny (press/hold space)")
		dialogBox.queue_lines("Ahh I see... My brother called for me... Friend is eeping... Alright take me to the tree *sigh*")
		playerdialog1 = true
		
	elif(area == treeArea):
		picked = false
		screenPan = true
		deparent()
		dialogBox.set_actor_name("Ronny")
		dialogBox.queue_lines("Sup Ron... I see that this goober fell asleep. No wonder it is so dark *cough* Lets get this over with *yawn*")
		self.rotation = 0
		dialogBox.dialog_complete.connect(dialog.bind())

func deparent():
	self.reparent($"/root")
	
	
func dialog():
	dialogBox.dialog_complete.disconnect(dialog.bind())
	dialogBox.set_actor_name("Ronny")
	dialogBox.queue_lines("Wakey Wakey")
	dialogBox.dialog_complete.connect(dialog1.bind())

func dialog1():
	dialogBox.dialog_complete.disconnect(dialog1.bind())
	dialogBox.set_actor_name("Ron")
	dialogBox.queue_lines("Eggs")
	dialogBox.dialog_complete.connect(dialog2.bind())
	
func dialog2():
	dialogBox.dialog_complete.disconnect(dialog2.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("and Bakey")
	dialogBox.dialog_complete.connect(dialog3.bind())
	
signal FinishGame
func dialog3():
	FinishGame.emit()
	
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
	elif(picked == true):
		print("put down")
		picked = false
		self.reparent($"/root")

