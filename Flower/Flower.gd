
extends Area2D

@export var LightRadius = 64
@export var delay = 0
var inLight = false
var isDisabled = true
@onready var TXCollision: CollisionShape2D = $CollisionShape2D
@onready var RXCollision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
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
	if area != $"." and not isDisabled:
		areas.append(area)
		call_deferred("on")
		Sprite.set_frame(1)
		light.enabled = true


func _on_area_2d_area_exited(area):
	areas.pop_back()
	if(areas.is_empty()):
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
