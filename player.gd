extends CharacterBody2D

const SPEED = 300.0

func _ready():
	return 0

func _physics_process(delta):
	var moveit = Input.get_vector("move_left","move_right","move_up","move_down")
	var direction = Vector2(moveit.x,moveit.y)
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	move_and_slide()
