extends Area2D

@export var areaSize = 20
@onready var collisionShape: CollisionPolygon2D = $LevelLightShape

var miniAreas = []
@onready var poly = collisionShape.get_polygon()
@onready var xmax = poly[0].x
@onready var xmin = poly[0].x
@onready var ymax = poly[0].y
@onready var ymin = poly[0].y
func _ready():
	getbounds()
	var colRect: RectangleShape2D = RectangleShape2D.new()
	colRect.set_size(Vector2(areaSize, areaSize))
	print(xmin, " " , xmax, " ", ymin, " ", ymax)
	var i = xmin
	while i < xmax:
		var j = ymin
		while j < ymax:
			var area: Area2D = Area2D.new()
			var colShape: CollisionShape2D = CollisionShape2D.new() 
			colShape.set_shape(colRect)
			area.set_collision_layer_value(1, false)
			area.set_collision_layer_value(2, true)
			area.set_collision_mask_value(1, false)
			area.set_collision_mask_value(2, true)
			area.add_child(colShape)
			area.position = Vector2(i, j)
			print(%Player.global_position, " ", area.global_position)
			area.mouse_entered.connect(test.bind(area))
			miniAreas.append(area)
			print("appendArea")
			j += areaSize
		i+= areaSize

func test(area):
	print("hehe", area)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getbounds():
	for i in poly:
		if(i.x > xmax):
			xmax = int(i.x)
		elif(i.x < xmin):
			xmin = int(i.x)
		elif(i.y > ymax):
			ymax = int(i.y)
		elif(i.y < ymin):
			ymin = int(i.y)
	
