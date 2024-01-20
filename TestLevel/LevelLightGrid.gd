extends Area2D
#
#@export var areaSize = 20
#@onready var collisionShape: CollisionPolygon2D = $LevelLightShape
#
#var miniAreas = []
#@onready var poly = collisionShape.get_polygon()
#@onready var xmax = poly[0].x
#@onready var xmin = poly[0].x
#@onready var ymax = poly[0].y
#@onready var ymin = poly[0].y
#@onready var detectArea = load("res://Light/light_detect_area.tscn")
#func _ready():
	#getbounds()
	#print(xmin, " " , xmax, " ", ymin, " ", ymax)
	#var i = xmin
	#while i < xmax:
		#var j = ymin
		#while j < ymax:
			#var area: Area2D = detectArea.instantiate()
			#area.position = Vector2(i, j)
			#miniAreas.append(area)
			#j += areaSize
		#i+= areaSize
#
#
#func test(area):
	#print("hehe", area)
#
#
#func _process(delta):
	#pass
#
#func getbounds():
	#for i in poly:
		#if(i.x > xmax):
			#xmax = int(i.x)
		#elif(i.x < xmin):
			#xmin = int(i.x)
		#elif(i.y > ymax):
			#ymax = int(i.y)
		#elif(i.y < ymin):
			#ymin = int(i.y)
	#
