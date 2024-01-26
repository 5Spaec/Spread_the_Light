extends Node2D

@export var rx: Node2D
@export var lightRadius: int = 64
#@onready var area: Area2D = $Area2D
@onready var pointLight: PointLight2D = $PointLight2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	rx.isLight.connect(lit.bind())
	call_deferred("off")
	pointLight.texture.width = lightRadius
	pointLight.texture.height = lightRadius
	pass



func lit(val : bool):
	if val:
		$AnimatedSprite2D.set_frame(1)
		call_deferred("on")
	else:
		$AnimatedSprite2D.set_frame(0)
		call_deferred("off")

func off():
	shape.disabled = true
	pointLight.visible = false
	
func on():
	shape.disabled = false
	pointLight.visible = true
