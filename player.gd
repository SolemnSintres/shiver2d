extends CharacterBody2D

@onready var anchor = $"../Anchor"

const SPEED = 300.0
const dashspeed = 900.0
const swingspeed = 400

var boost = 0.0
var boost_direction = Vector2.ZERO
var cooldown = 1.0
var swinging = false
var rope_length = 0.0


func _ready():
	return 0

func _physics_process(delta):
	var gap = global_position.distance_to(get_global_mouse_position())
	var rope = global_position - anchor.global_position
	
	## AIM ONLY WHEN CURSOR IS 30PX AWAY ##
	if gap > 30 and not swinging:
		look_at(get_global_mouse_position())
	
	## SWING PRESSED ##
	if Input.is_action_just_pressed("swing"):
		swinging = not swinging
		if swinging:
			rope_length = rope.length()
	
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
	
	## DASH SLOWS DOWN ##
	if boost > 0:
		boost -= delta
		velocity = boost_direction * 900.0
	
	## CALCULATE THE DISTANCE OF PLAYER TO ANCHOR ##
	if swinging:
		velocity = rope.orthogonal().normalized() * swingspeed
	
	move_and_slide()
	
	## NEW ROPE IS THE MEASUREMENT AFTER THE SWING. SO WE CAN KEEP THE DISTANCE EXACTLY THE SAME AND NOT INCREASE ##
	var new_rope = global_position - anchor.global_position
	if swinging:
		global_position = anchor.global_position + new_rope.normalized() * rope_length
