
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
		dialogA()
		playerdialog1 = true
		
	elif(area == treeArea):
		picked = false
		screenPan = true
		deparent()
		dialogBox.set_actor_name("Oriel")
		dialogBox.queue_lines("Quick everybody, speak our sacred words so that we may wake the sacred King of Light and finally spread light throughout the land.")
		self.rotation = 0
		dialogBox.dialog_complete.connect(dialog.bind())

func dialogA():
	dialogBox.dialog_complete.disconnect(dialogA.bind())
	dialogBox.set_actor_name("Gelic")
	dialogBox.queue_lines("Hello young man! My name is Gelic. *Yawns* How long was I sleeping for?")
	dialogBox.dialog_complete.connect(dialogB.bind())

func dialogB():
	dialogBox.dialog_complete.disconnect(dialogB.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("I don’t know, but Oriel said I needed to take you back to the tree room.")
	dialogBox.dialog_complete.connect(dialogC.bind())

func dialogC():
	dialogBox.dialog_complete.disconnect(dialogC.bind())
	dialogBox.set_actor_name("Gelic")
	dialogBox.queue_lines("Then what are we waiting for?! Pull me out of the ground, I’ve probably been here for too long anyway.")
	#dialogBox.dialog_complete.connect(dialogC.bind())

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
	dialogBox.dialog_complete.disconnect(dialog3.bind())
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

