extends CharacterBody2D

const SPEED = 300.0
const TURN_RATE = 4.0
const DASH_TIME = 0.3

var boost = 0.0
var boost_direction = Vector2.ZERO
var cooldown = 1.0

func _physics_process(delta):
	var gap = global_position.distance_to(get_global_mouse_position())
	
	## AIM ONLY WHEN CURSOR IS 30PX AWAY ##
	if gap > 30:
		look_at(get_global_mouse_position())
	
	## MOVEIT IS THE DIRECTION ##
	var moveit = Input.get_vector("move_left","move_right","move_up","move_down")
	var direction = Vector2(moveit.x,moveit.y)
	
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
		boost = DASH_TIME
		cooldown = 1.0
	
	## ACTIVE DASH ##
	if boost > 0:
		boost -= delta
		var progress = boost/DASH_TIME
		velocity = boost_direction * 1200.0 * progress
		var direct = global_position.direction_to(get_global_mouse_position())
		var angleboost = boost_direction.angle_to(direct)
		boost_direction = boost_direction.rotated(angleboost * TURN_RATE * delta) 
	
	move_and_slide()
