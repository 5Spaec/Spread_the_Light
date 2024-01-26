extends CharacterBody2D

@export var speed: int = 20;
@export var camera: Camera2D;
@export var audio: AudioStreamPlayer2D
@export var walkAudio: AudioStreamPlayer2D
@export var plantAudio: AudioStreamPlayer2D
@export var sprite: AnimatedSprite2D
@export var particles: GPUParticles2D
@export var dialogBox: Control
@onready var speedCopy = speed
@onready var zoomCopy = camera.zoom
@onready var inLight = true
@onready var rand: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var checkpointPos: Vector2 = self.global_position
@onready var timer: Timer = Timer.new()
var gameover = false
var interacts = []
func _ready():
	add_child(timer)
	timer.timeout.connect(die.bind())
	walkAudio.play()
	walkAudio.stream_paused = true
	dialogBox.set_actor_name("You (press/hold space)")
	dialogBox.queue_lines("Woah where am I?")
	dialogBox.dialog_complete.connect(dialog.bind())
	speed = 0
	
	pass

func dialog():
	dialogBox.dialog_complete.disconnect(dialog.bind())
	dialogBox.set_actor_name("You (press/hold space)")
	dialogBox.queue_lines("I don’t remember where I came in at… I guess the only way out is forward.")
	dialogBox.dialog_complete.connect(dialog1.bind())

func dialog1():
	dialogBox.dialog_complete.disconnect(dialog1.bind())
	dialogBox.set_actor_name("???")
	dialogBox.queue_lines("Hey kid! Come give me a hand.")
	dialogBox.dialog_complete.connect(dialog2.bind())
	
func dialog2():
	dialogBox.dialog_complete.disconnect(dialog2.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Woah is that plant talking??")
	dialogBox.dialog_complete.connect(dialog3.bind())

func dialog3():
	dialogBox.dialog_complete.disconnect(dialog3.bind())
	dialogBox.set_actor_name("Sir Barret")
	dialogBox.queue_lines("Hey kid, I’m not just “some plant.” You’re talking to Sir Barret, son of Harman the Great. I don’t have much time for chit chat, I need you to turn me to shine at my brother over in the darkness and follow the light")
	speed = speedCopy

	
func _process(delta):
	var offsetNum = 0.4
	if not inLight:
		camera.offset = Vector2(rand.randf_range(-offsetNum, offsetNum), rand.randf_range(-offsetNum, offsetNum))
	

func _physics_process(delta):
	velocity = Vector2.ZERO
	var move = false
	var audioOn = false
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		if not move:
			move = true
			sprite.play("move_right")
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		if not move:
			move = true
			sprite.play("move_left")
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		if not move:
			move = true
			sprite.play("move_down")
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		if not move:
			move = true
			sprite.play("move_up")
	

	if velocity.length() > 0:
		walkAudio.stream_paused = false
		velocity = velocity.normalized() * speed
	else:
		walkAudio.stream_paused = true

		sprite.stop()
		move = false
	position += velocity * delta
	move_and_slide()


func _on_spinny_plant_interacting(isInteracting: bool):
	if(isInteracting):
		interacts.append(0)
		speed = 0
		var tween = create_tween()
		plantAudio.play()		
		tween.tween_property(camera, "zoom", Vector2(3.5, 3.5), 0.3).set_trans(Tween.TRANS_SINE)
	else:
		interacts.pop_back()
		plantAudio.play()				
		if(interacts.is_empty()):
			speed = speedCopy
		var tween = create_tween()
		tween.tween_property(camera, "zoom", zoomCopy, 0.3).set_trans(Tween.TRANS_SINE)




signal playerLight
var enteredAreas = [];
func _on_player_mirror_detect_area_entered(area):
	#print("EnteredLight")
	enteredAreas.append(area)
	playerLight.emit(true)
	inLight = true
	audio.stop()
	AudioServer.set_bus_volume_db(2, 0)
	camera.offset = Vector2(0, 0)
	timer.stop()
	particles.emitting = false
	particles.visible = false
	particles.restart()


func _on_player_mirror_detect_area_exited(area):
	enteredAreas.pop_back()
	if(enteredAreas.is_empty() and not gameover):
		inLight = false
		playerLight.emit(false)
		audio.play()
		AudioServer.set_bus_volume_db(2, -72)
		#timer.start(9.75)
		timer.start(3)
		particles.visible = true
		particles.emitting = true
		
		
		
	
func die():
	self.position = checkpointPos



func _on_player_checkpoint_collision_area_entered(area):
	checkpointPos = area.global_position
	


func _on_cam_tx_switch_cam(pos: Vector2, sendPlayer: bool):
	if(sendPlayer):
		plantAudio.play()
		speed = 0
		interacts.append(1)
		var tween = create_tween()
		tween.tween_property(camera, "position", to_local(pos), 0.3).set_trans(Tween.TRANS_SINE)
	else:
		interacts.pop_back()
		if(interacts.is_empty()):
			speed = speedCopy
		plantAudio.play()		
		var tween = create_tween()
		tween.tween_property(camera, "position", Vector2(0,0), 0.3).set_trans(Tween.TRANS_SINE)
	pass


func _on_ending_light_game_over():
	gameover = true
	pass
