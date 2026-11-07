extends CharacterBody2D

@onready var anchor = $"../Anchor"
@onready var ray = $RayCast2D

const SPEED = 300.0
const swing_base = 200.0

var swingspeed = 200.0
var boost = 0.0
var boost_direction = Vector2.ZERO
var cooldown = 1.0
var swinging = false
var rope_length = 0.0
var swing_dir = 1.0
var fling = Vector2.ZERO

func _physics_process(delta):
	var gap = global_position.distance_to(get_global_mouse_position())
	var rope = global_position - anchor.global_position
	
	## AIM ONLY WHEN CURSOR IS 30PX AWAY ##
	if gap > 30 and not swinging:
		look_at(get_global_mouse_position())
	
		## MOVEIT IS THE DIRECTION ##
	var moveit = Input.get_vector("move_left","move_right","move_up","move_down")
	var direction = Vector2(moveit.x,moveit.y)
	
	## SWING PRESSED ##
	if Input.is_action_just_pressed("swing"):
		if swinging:
			swinging = false
			fling = velocity
		elif ray.is_colliding():
			swinging = true
			anchor.global_position = ray.get_collision_point()
			var newnew_rope = global_position-anchor.global_position
			rope_length = newnew_rope.length()
			var rope_move_dir = moveit.dot(newnew_rope.orthogonal())
			if rope_move_dir > 0:
				swing_dir = 1.0
			else:
				swing_dir = -1.0
	
	
	## MOVEMENT ##
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	
	## DASH COOLDOWN STARTS WHEN ITS NOT ZERO ##
	if cooldown > 0.0:
		cooldown -= delta
	
	
	## DASH ##
	if Input.is_action_just_pressed("dash") and cooldown <= 0.0:
		boost_direction = transform.x
		if moveit.length() > 0:
			boost_direction = moveit
		boost = 0.15 
		cooldown = 1.0
		if swinging:
			swingspeed = 500.0
	
	## ACTIVE DASH ##
	if boost > 0:
		boost -= delta
		velocity = boost_direction * 400.0
	
	## SWINGING? OR NOT SWINGING ##
	if swinging: 
		velocity = rope.orthogonal().normalized() * swingspeed * swing_dir
	
	fling = fling.move_toward(Vector2.ZERO,800 * delta)
	swingspeed = move_toward(swingspeed, swing_base, 400 * delta)
	velocity += fling
	move_and_slide()
	
	if get_slide_collision_count() > 0 and swinging:
		swinging = false
		fling = velocity.limit_length(500.0) # Slide On The Wall After Collision
	
	## NEW ROPE IS THE MEASUREMENT AFTER THE SWING. SO WE CAN KEEP THE DISTANCE EXACTLY THE SAME AND NOT INCREASE ##
	var new_rope = global_position - anchor.global_position
	if swinging:
		global_position = anchor.global_position + new_rope.normalized() * rope_length
