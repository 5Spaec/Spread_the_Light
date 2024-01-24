extends Node2D

@export var rx: Node2D
@export var lightRadius: int = 64
#@onready var area: Area2D = $Area2D
@onready var pointLight: PointLight2D = $PointLight2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
var inLight = false
# Called when the node enters the scene tree for the first time.
func _ready():
	rx.isLight.connect(lit.bind())
	rx.isButtonOn.connect(buttonClick.bind())
	call_deferred("off")
	pointLight.texture.width = lightRadius
	pointLight.texture.height = lightRadius



func lit(val : bool):
	if val:
		$AnimatedSprite2D.set_frame(1)
		call_deferred("on")
	else:
		$AnimatedSprite2D.set_frame(0)
		call_deferred("off")
	inLight = val

signal switchCam
func buttonClick(val: bool):
	if inLight:
		switchCam.emit(global_position, true)
		

func off():
	shape.disabled = true
	pointLight.visible = false
	
func on():
	shape.disabled = false
	pointLight.visible = true


func _on_tx_click_detect_pressed():
	switchCam.emit(global_position, false)
