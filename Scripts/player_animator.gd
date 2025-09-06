extends AnimatedSprite2D
@export var player_controller : PlayerController
#@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_sprite_flip()
	_choose_animation()

func _handle_sprite_flip() -> void:
	if player_controller.direction == 1:
		flip_h = false
	elif player_controller.direction == -1:
		flip_h = true

func _choose_animation() -> void:
	
	if player_controller.airborne:
		if player_controller.jumping:
			play("jump")
			player_controller.jumping = false
		elif player_controller.double_jumping:
			play("double_jump")
			player_controller.double_jumping = false
		elif player_controller.falling:
			play("fall")
		return
	
	if player_controller.walking:
		play("walk")
	elif player_controller.sprinting:
		play("sprint")
	elif player_controller.crouching:
		play("crouch")
	elif player_controller.crawling:
		play("crawl")
	else:
		play("idle")
