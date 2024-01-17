extends Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var door: StaticBody2D = $AnimatedSprite2D/StaticBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var lights = []
func _on_area_entered(area):
	lights.append(area)
	sprite.set_frame(1)
	door.set_collision_layer_value(1, false)
	pass # Replace with function body.


func _on_area_exited(area):
	lights.pop_back()
	if(lights.is_empty()):
		sprite.set_frame(0)
		door.set_collision_layer_value(1, true)
	pass # Replace with function body.
