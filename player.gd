extends CharacterBody2D

@onready var anchor = $"../Anchor"

const SPEED = 300.0
const dashspeed = 900.0
var boost = 0.0
var boost_direction = Vector2.ZERO
var cooldown = 1.0
var swinging = false

func _ready():
	return 0

func _physics_process(delta):
	var gap = global_position.distance_to(get_global_mouse_position())
	if gap > 30 and not swinging:
		look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("swing"):
		swinging = not swinging
	
	var moveit = Input.get_vector("move_left","move_right","move_up","move_down")
	var direction = Vector2(moveit.x,moveit.y)
	
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	
	if cooldown > 0.0:
		cooldown -= delta
	
	if Input.is_action_just_pressed("dash") and cooldown <= 0.0:
		boost_direction = transform.x
		if moveit.length() > 0:
			boost_direction = moveit
		boost = 0.15 
		cooldown = 1.0
	
	if boost > 0:
		boost -= delta
		velocity = boost_direction * 900.0
	
	move_and_slide()
	
