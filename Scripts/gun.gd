extends Sprite2D

@export var bullet_speed = 1000
@export var fire_rate = 0.2

var bullet = preload("res://Scenes/Weapons/bullet.tscn")
var can_fire = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_set_direction()
	if Input.is_action_pressed("shoot") and can_fire:
		_shoot()
		can_fire = false
		await(get_tree().create_timer(fire_rate).timeout)
		can_fire = true
	pass

func _set_direction() -> void:
	look_at(get_global_mouse_position())
	# If pointing left (rotation between 90° and 270° in radians),
	# flip vertically
	if rotation > PI/2 or rotation < -PI/2:
		flip_v = true
	else:
		flip_v = false

func _shoot() -> void:
	var bullet_instance = bullet.instantiate()
	var gun_tip = $gun_tip
	bullet_instance.position = gun_tip.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet_instance)
