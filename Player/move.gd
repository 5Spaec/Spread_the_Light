extends CharacterBody2D

@export var speed: int = 20;
@export var camera: Camera2D;
@export var audio: AudioStreamPlayer2D
@export var sprite: AnimatedSprite2D
@export var particles: GPUParticles2D
@export var dialogBox: Control
@onready var speedCopy = speed
@onready var zoomCopy = camera.zoom
@onready var inLight = true
@onready var rand: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var checkpointPos: Vector2 = self.global_position
@onready var timer: Timer = Timer.new()
var interacts = []
func _ready():
	add_child(timer)
	timer.timeout.connect(die.bind())
	dialogBox.set_actor_name("You (press/hold space)")
	dialogBox.queue_lines("How did I get here?? Why is it so dark??")
	pass

func _process(delta):
	var offsetNum = 0.4
	if not inLight:
		camera.offset = Vector2(rand.randf_range(-offsetNum, offsetNum), rand.randf_range(-offsetNum, offsetNum))
	

func _physics_process(delta):
	velocity = Vector2.ZERO
	var move = false
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
		velocity = velocity.normalized() * speed
	else:
		sprite.stop()
		move = false
	position += velocity * delta
	move_and_slide()


func _on_spinny_plant_interacting(isInteracting: bool):
	if(isInteracting):
		interacts.append(0)
		speed = 0
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(3.5, 3.5), 0.3).set_trans(Tween.TRANS_SINE)
	else:
		interacts.pop_back()
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
	if(enteredAreas.is_empty()):
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
		speed = 0
		interacts.append(1)
		var tween = create_tween()
		tween.tween_property(camera, "position", to_local(pos), 0.3).set_trans(Tween.TRANS_SINE)
	else:
		interacts.pop_back()
		if(interacts.is_empty()):
			speed = speedCopy
		var tween = create_tween()
		tween.tween_property(camera, "position", Vector2(0,0), 0.3).set_trans(Tween.TRANS_SINE)
	pass
