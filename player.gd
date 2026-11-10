extends CharacterBody2D

const SPEED = 300.0

var boost = 0.0
var boost_direction = Vector2.ZERO
var cooldown = 1.0
@onready var pin = $Pin
var pin_timer = 0.0

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
		boost = 0.15 
		cooldown = 1.0
	
	## ACTIVE DASH ##
	if boost > 0:
		boost -= delta
		velocity = boost_direction * 400.0
	
	if Input.is_action_just_pressed("stab") and pin_timer <= 0.0:
		pin_timer = 0.15
	pin.monitoring = pin_timer > 0.0
	if pin_timer > 0.0:
		pin_timer -= delta
		for thing in pin.get_overlapping_bodies():
			if thing == self:
				continue
			print(thing.name)
	
	
	move_and_slide()
