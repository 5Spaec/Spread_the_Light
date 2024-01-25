extends AnimatedSprite2D
@export var clickItem: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	clickItem.interacting.connect(_on_spinny_plant_interacting.bind())
	#visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spinny_plant_interacting(val):
	visible = false
