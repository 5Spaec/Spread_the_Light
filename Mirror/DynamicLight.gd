extends Polygon2D

@export var rayAmount: int = 10
@export var lightWidth: int = 20
@export var rayLength: int = 1000
@onready var collisionShape: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var pointLight: PointLight2D = $"../PointLight2D"
@onready var particle: GPUParticles2D = $"../PointLight2D/GPUParticles2D"
var rays = []
var inLight = false
var points = PackedVector2Array()
var spreadDist: float = lightWidth / rayAmount
var maxRayDist = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	points.resize(rayAmount+2)
	for i in range(rayAmount):
		var ray: RayCast2D = RayCast2D.new()
		add_child(ray)
		ray.position = (Vector2((-(lightWidth/2)) + (spreadDist * i) + spreadDist/2, 0))
		ray.target_position = (Vector2(0, -rayLength))
		ray.enabled = true
		ray.hit_from_inside = true
		#ray.collide_with_areas = true
		#ray.set_collision_mask_value(1, true)
		#ray.set_collision_mask_value(2, true)
		rays.append(ray)
	points[rayAmount] = rays[-1].position
	points[rayAmount + 1] = rays[0].position
	stopEffects()
	clearShapes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	maxRayDist = 0
	if inLight:
		for i: int in range(rayAmount):
			# checks for if the ray is colliding and is in the light if not then the light should turn off
			if rays[i].is_colliding():
				points[i] = to_local(rays[i].get_collision_point())
			# for some reason in godot whenever a ray does not hit anything it returns 0 0 so this is here just incase a 0 0 is returned
			else:
				points[i] = (Vector2(-lightWidth + (spreadDist * i) + (lightWidth/2), -rayLength))
			# this gets the longest ray so that we can determine how far to push the light later
			if(abs(points[i].y) > maxRayDist):
				maxRayDist = abs(points[i].y)
		#print(maxRayDist)
		# sets the shape of the light and the collisionbox to be the same as the points defined earlier	
		self.set_polygon(points)
		collisionShape.set_polygon(points)
		drawEffects(maxRayDist)
		startShapes()
	else:
		clearShapes()
		stopEffects()
		
# the way the next 2 functions work is that if an area is entered it is added to an array
# once any area is exited, the last item in the array is removed
# this is important because it fixes a bug where lights will stop shining if they exit one area and are still in another area
signal turnon
var enteredAreas = [];
func _on_mirror_detect_2_area_entered(area):
	#print("EnteredLight")
	enteredAreas.append(area)
	turnon.emit()
	inLight = true

signal turnoff
func _on_mirror_detect_2_area_exited(area):
	enteredAreas.pop_back()
	if(enteredAreas.is_empty()):
		inLight = false
		stopEffects()
		turnoff.emit()

# simple functions to draw and stop drawing particeles and such to the screen
func drawEffects(dist):
	# lights
	#var tween = create_tween()
	
	pointLight.scale = Vector2((dist/1000), 0.23)
	#tween.tween_property(pointLight, "scale", Vector2((dist/1000), 0.23), 0.1).set_trans(Tween.TRANS_SINE)
	pointLight.position = Vector2(0, -dist/2)
	#tween.tween_property(pointLight, "position", Vector2(0, -dist/2), 0.1).set_trans(Tween.TRANS_SINE)
	
	# particles
	#particle.scale = Vector2(dist/1000, 0.5)
	particle.set_emitting(true)
	#particle.position = Vector2(dist, 0)
	

func stopEffects():
	# lights
	pointLight.scale = Vector2(0, 0)
	pointLight.position = Vector2(0, 0)
	
	# particles
	particle.set_emitting(false)

func clearShapes():
	collisionShape.disabled = true
	self.visible = false

func startShapes():
	collisionShape.disabled = false
	self.visible = true
