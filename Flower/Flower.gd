
extends Area2D

@export var LightRadius = 64
@export var delay = 0
var inLight = false
@onready var TXCollision: CollisionShape2D = $CollisionShape2D
@onready var RXCollision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
# Called when the node enters the scene tree for the first time.
func _ready():
	light.texture.width = LightRadius
	light.texture.height = LightRadius
	TXCollision.shape.radius = LightRadius/2
	TXCollision.disabled = true
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




var areas = []
func _on_area_2d_area_entered(area):
	if area != $".":
		areas.append(area)
		call_deferred("on")
		Sprite.set_frame(1)


func _on_area_2d_area_exited(area):
	areas.pop_back()
	if(areas.is_empty()):
		inLight = false
		call_deferred("off")
		Sprite.set_frame(0)
		


func on():
	inLight = true
	TXCollision.disabled = false
	
	
func off():
	inLight = false
	TXCollision.disabled = true
	
