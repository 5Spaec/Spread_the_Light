extends Polygon2D

@export var rayAmount: int = 30
@export var lightWidth: int = 90
@export var rayLength: int = 1000
var rays = []

var points = PackedVector2Array()
var inLight = true
var spreadDist: float = lightWidth / rayAmount
# Called when the node enters the scene tree for the first time.
func _ready():
	points.resize(rayAmount+2)
	for i in range(rayAmount):
		var ray: RayCast2D = RayCast2D.new()
		ray.position = (Vector2(-lightWidth + (spreadDist * i) + (lightWidth/2), 0))
		ray.target_position = (Vector2(-lightWidth + (spreadDist * i)/2 + (lightWidth/2), -rayLength))
		add_child(ray)
		ray.enabled = true
		ray.collide_with_areas = true
		rays.append(ray)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for i: int in range(rayAmount):
		if rays[i].is_colliding() and inLight:
			points[i] = to_local(rays[i].get_collision_point())
			
		else:
			points[i] = (Vector2(-lightWidth + (spreadDist * i) + (lightWidth/2), -rayLength))
			
	points[rayAmount] = rays[-1].position
	points[rayAmount + 1] = rays[0].position
	self.set_polygon(points)
	pass
	
#func getCollisionPoint():
	#var collisionPoint: Vector2 
	#if raycast.is_colliding():
		#collisionPoint = to_local(raycast.get_collision_point())
	#else:
		#collisionPoint.x = 0;
		#collisionPoint.y = raycastTip.position.y;
	#return collisionPoint
