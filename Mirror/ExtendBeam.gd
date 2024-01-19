extends Line2D

#@export var raycast: RayCast2D
#@export var raycastTip: Node2D
#@export var LightCollision: CollisionShape2D
#@onready var pointLight: PointLight2D = $"../PointLight2D"
#@onready var particle: GPUParticles2D = $"../PointLight2D/GPUParticles2D"
#var inLight = false
#var collide = false
#var colissionRect: RectangleShape2D = RectangleShape2D.new()
#var enteredAreas = [];
#func _ready():
	#LightCollision.shape = colissionRect
	#reset()
	#call_deferred("disableRay")

#func _physics_process(delta):
	#raycast.force_raycast_update()
	#if raycast.is_colliding() and inLight:
		#reset()
		#putPoints(raycast.position, getCollisionPoint())
		#collide = true
	#elif collide:
		#reset()
		#putPoints(raycast.position, getCollisionPoint())
		#collide = false
		#
	#pass


#func _on_mirror_detect_2_area_entered(area):
	## find out how far wwto send the line later
	#var collisionPoint: Vector2 = getCollisionPoint()
	## now time to make the line have a point at that global position and one at local position 0 0
	#reset()
	#putPoints(raycast.position, collisionPoint)
	#enteredAreas.append(area)
	#inLight = true
	#print(collisionPoint)
	#pass

#signal turnoff
#func _on_mirror_detect_2_area_exited(area):
	#enteredAreas.pop_back()
	#if(enteredAreas.is_empty()):
		#call_deferred("disableRay")
		#reset()
		#inLight = false
		#turnoff.emit()
		
	

#func reset():
	#self.clear_points()
	#pointLight.scale = Vector2(0, 0)
	#pointLight.position = Vector2(0, 0)
	#particle.set_emitting(false)

#func disableRay():
	#LightCollision.disabled = true
	#colissionRect.set_size(Vector2(100, 0))
	#$Area2D.set_position(Vector2(0, 0))
	#reset()

#func enableRay():
	#LightCollision.disabled = false

#func getCollisionPoint():
	#var collisionPoint: Vector2 
	#if raycast.is_colliding():
		#collisionPoint = to_local(raycast.get_collision_point())
	#else:
		#collisionPoint.x = 0;
		#collisionPoint.y = raycastTip.position.y;
	#return collisionPoint

#func putPoints(point1: Vector2, point2: Vector2):
	#call_deferred("enableRay")
	#self.add_point(point1, 0)
	#point2.y -= 10
	#self.add_point(point2, 1)
	##lights
	#pointLight.scale = Vector2(abs(point2.y)/1000, 1)
	#pointLight.position = Vector2(0, point2.y/2)
	#
	##particles
	#particle.scale = Vector2(abs(point2.y)/1000, 0.5)
	##particle.position = Vector2(point2.y/2, point2.y/2)
	#
	##rect
	#colissionRect.set_size(Vector2(100, abs(point2.y)))
	#$Area2D.set_position(Vector2(0, point2.y/2))
	#particle.set_emitting(true)
