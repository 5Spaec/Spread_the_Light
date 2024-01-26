
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
		playerdialog1 = true
		dialog()		
	elif(area == treeArea):
		picked = false
		call_deferred("deparent")
		self.rotation = 0
		dialogA()
	elif area != $"." and not isDisabled:
		areas.append(area)
		call_deferred("on")
		Sprite.set_frame(1)
		light.enabled = true

func dialog():
	#dialogBox.dialog_complete.disconnect(dialog.bind())
	dialogBox.set_actor_name("???")
	dialogBox.queue_lines("Little one, I need you to help me.")
	dialogBox.dialog_complete.connect(dialog1.bind())

func dialog1():
	dialogBox.dialog_complete.disconnect(dialog1.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Before I do anymore, I want to know more about this whole situation.")
	dialogBox.dialog_complete.connect(dialog2.bind())

func dialog2():
	dialogBox.dialog_complete.disconnect(dialog2.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("Of course, where are my manners. My name is Oriel, and I am an heir to the kingdom of light.")
	dialogBox.dialog_complete.connect(dialog3.bind())
	
func dialog3():
	dialogBox.dialog_complete.disconnect(dialog3.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("What does that mean?")
	dialogBox.dialog_complete.connect(dialog4.bind())
	
func dialog4():
	dialogBox.dialog_complete.disconnect(dialog4.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("I am very sorry little one, but we do not have time for that conversation.")
	dialogBox.dialog_complete.connect(dialog5.bind())
	
func dialog5():
	dialogBox.dialog_complete.disconnect(dialog5.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("I need you to uproot me and take me through that door. If you do, I promise to answer all your questions when the time is right.")
	dialogBox.dialog_complete.connect(dialog6.bind())

func dialog6():
	dialogBox.dialog_complete.disconnect(dialog6.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Uproot you? Won’t that kill you?")
	dialogBox.dialog_complete.connect(dialog7.bind())
	
func dialog7():
	dialogBox.dialog_complete.disconnect(dialog7.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("You needn’t worry about that little one, just take me through the door down this hallway and I’ll be fine.")
	#dialogBox.dialog_complete.connect(dialog8.bind())

func dialogA():
	#dialogBox.dialog_complete.disconnect(dialogA.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Now will you answer my question?")
	dialogBox.dialog_complete.connect(dialogB.bind())
	
func dialogB():
	dialogBox.dialog_complete.disconnect(dialogB.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("Not yet, you must bring the others to this tree, only then will light be restored.")
	dialogBox.dialog_complete.connect(dialogC.bind())

func dialogC():
	dialogBox.dialog_complete.disconnect(dialogC.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("You said you’d answer my questions!")
	dialogBox.dialog_complete.connect(dialogD.bind())

func dialogD():
	dialogBox.dialog_complete.disconnect(dialogD.bind())
	dialogBox.set_actor_name("Oriel")
	dialogBox.queue_lines("I am sorry little one, we do not have time. We must restore light. Go!")
	dialogBox.dialog_complete.connect(moveCamToDoor.bind())

func deparent():
	self.reparent($"/root")
	
func moveCamToDoor():
	dialogBox.dialog_complete.disconnect(moveCamToDoor.bind())
	var tween = create_tween()
	tween.tween_property(playerCamera, "global_position", doorPoint.global_position, 0.3).set_trans(Tween.TRANS_SINE)
	var timer: Timer = Timer.new()
	add_child(timer)
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
		
