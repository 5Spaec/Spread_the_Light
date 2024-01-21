extends CharacterBody2D

@export var speed: int = 20;
@export var camera: Camera2D;
@export var audio: AudioStreamPlayer2D
@onready var speedCopy = speed
@onready var zoomCopy = camera.zoom
@onready var inLight = true

func _ready():
	pass



func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	move_and_slide()


func _on_spinny_plant_interacting(isInteracting: bool):
	var tween = create_tween()
	if(isInteracting):
		speed = 0
		tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 0.3).set_trans(Tween.TRANS_SINE)
	else:
		speed = speedCopy
		tween.tween_property(camera, "zoom", zoomCopy, 0.3).set_trans(Tween.TRANS_SINE)




signal playerLight
var enteredAreas = [];
func _on_player_mirror_detect_area_entered(area):
	print("EnteredLight")
	enteredAreas.append(area)
	playerLight.emit(true)
	inLight = true
	audio.stop()


func _on_player_mirror_detect_area_exited(area):
	enteredAreas.pop_back()
	if(enteredAreas.is_empty()):
		inLight = false
		playerLight.emit(false)
		audio.play()
		
	


