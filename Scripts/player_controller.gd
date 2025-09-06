class_name PlayerController extends CharacterBody2D


@export var speed = 300.0
@export var jump_power = 300.0
@export var sprint_multiplier = 1.5
@export var crawl_multiplier = 0.2

var direction = 0

# Ground States
var sprinting = false
var idling = true
var walking = false
var crouching = false
var crawling = false

# Air States
var jumping = false
var double_jumping = false
var airborne = false
var falling = false
var double_jumps_left = 0
@export var air_jumps = 1
@export var air_acceleration = 0.2

#Walls
@export var wall_jump_power = 100
@export var wall_jump_pushback = 1000


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if not airborne:
			airborne = true
			double_jumps_left = air_jumps
		
		falling = false
		if velocity.y > 0:
			falling = true
	else:
		airborne = false
	
	if not airborne:
		handle_ground_movement()
	else:
		handle_air_movement()
	if Input.is_action_just_pressed("jump"):
		handle_jump()
		
	move_and_slide()

func handle_jump() -> void:
	if is_on_floor():
		velocity.y = -jump_power
		jumping = true
	elif is_on_wall_only():
		velocity.y = -wall_jump_power
		if Input.is_action_pressed("move_right"):
			velocity.x = -wall_jump_pushback
			print("velocity after airjump: ", velocity.x)
		elif Input.is_action_pressed("move_left"):
			velocity.x = wall_jump_pushback
			print("velocity after airjump: ", velocity.x)
			
			
	elif double_jumps_left > 0:
		double_jumps_left -= 1
		velocity.y = -jump_power
		double_jumping = true
		falling = false
			
		
	
func handle_ground_movement() -> void:
	direction = Input.get_axis("move_left", "move_right")
	if not direction:
		if Input.is_action_pressed("crouch"):
			crouching = true
		else:
			crouching = false
			idling = true
		walking = false
		sprinting = false
		velocity.x = 0
		return
		
	idling = false

	velocity.x = direction * speed
	if Input.is_action_pressed("sprint"):
		sprinting = true
		walking = false
		velocity.x = velocity.x * sprint_multiplier
	elif crouching:
		crawling = true
		velocity.x = velocity.x * crawl_multiplier
	else:
		sprinting = false
		crawling = false
		walking = true
	
func handle_air_movement() -> void:
	#print("current velocity: ", velocity.x)
	direction = Input.get_axis("move_left", "move_right")
	if not direction:
		#Player mantains direction
		return
	
	var desired_speed = speed * direction
	var acceleration_rate = desired_speed * air_acceleration
	
	if desired_speed != velocity.x:
		if desired_speed < 0 and velocity.x > desired_speed or desired_speed > 0 and velocity.x < desired_speed:
			velocity.x += acceleration_rate
	
