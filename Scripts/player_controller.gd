class_name PlayerController extends CharacterBody2D


@export var speed = 300.0
@export var jump_power = 300.0
@export var sprint_multiplier = 1.5
@export var crawl_multiplier = 0.2

var direction = 0
var global_delta = 0
# Ground States
var sprinting = false
var idling = false
var walking = false
var crouching = false
var crawling = false
var grounded =  false

# Air States
var jumping = false
var double_jumping = false
var airborne = false
var falling = false
var clinging = false
var double_jumps_left = 0

# Air Movement
@export var air_jumps = 1
@export var air_acceleration = 0.2

#Walls
@export var wall_jump_power = 100
@export var wall_jump_pushback = 1000


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_delta = delta
	direction = Input.get_axis("move_left", "move_right")
	setup_initial_states()
	
	if not airborne:
		handle_ground_movement()
	else:
		handle_air_movement()
	if Input.is_action_just_pressed("jump"):
		handle_jump()
		
	move_and_slide()

func setup_initial_states() -> void:
	
	# Ground States
	sprinting = false
	idling = false
	walking = false
	crouching = false
	crawling = false
	
	if is_on_floor():
		airborne = false
		setup_ground_states()
	else:
		setup_air_states()
		grounded = false
	pass 

func setup_ground_states() -> void:
	grounded = true
	if Input.is_action_pressed("crouch"):
		if direction:
			crawling = true
		else:
			crouching = true
		return
	if not direction:
		idling = true
		return
	else:
		if Input.is_action_pressed("sprint"):
			sprinting = true
		else:
			walking = true
		return

func setup_air_states() -> void:
	velocity += get_gravity() * global_delta
	
	# setup initial airborne and give double jumps
	if not airborne:
		airborne = true
		double_jumps_left = air_jumps
	
	# Check if player is falling
	falling = false
	if velocity.y > 0:
		falling = true
	pass

func handle_jump() -> void:
	if not airborne:
		velocity.y = -jump_power
		jumping = true
	elif is_on_wall_only():
		velocity.y = -wall_jump_power
		if Input.is_action_pressed("move_right"):
			velocity.x = -wall_jump_pushback
		elif Input.is_action_pressed("move_left"):
			velocity.x = wall_jump_pushback
		print("velocity x after airjump: ", velocity.x)
			
			
	elif double_jumps_left > 0:
		double_jumps_left -= 1
		velocity.y = -jump_power
		double_jumping = true
		falling = false
			
		
	
func handle_ground_movement() -> void:
	
	if idling or crouching:
		velocity.x = 0
		return
		
	if sprinting:
		velocity.x = direction * speed * sprint_multiplier
	elif crawling:
		velocity.x = direction * speed * crawl_multiplier
	elif walking:
		velocity.x = direction * speed
	return
	
func handle_air_movement() -> void:
	if not direction:
		#Player mantains direction
		return
	
	var desired_speed = speed * direction
	var acceleration_rate = desired_speed * air_acceleration
	
	if desired_speed != velocity.x:
		if desired_speed < 0 and velocity.x > desired_speed or desired_speed > 0 and velocity.x < desired_speed:
			velocity.x += acceleration_rate
	
