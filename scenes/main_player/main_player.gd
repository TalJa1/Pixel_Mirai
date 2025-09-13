extends CharacterBody2D

# CharacterBody2D movement script for Player_body2d
# - Uses _physics_process for consistent movement
# - Switches AnimatedSprite2D animations between run/idle for up/down/side
# - Flips the sprite horizontally when moving left

var speed = 180.0

var anim = null
var last_dir = Vector2.DOWN

func _ready():
	if has_node("AnimatedSprite2D"):
		anim = $AnimatedSprite2D

func _physics_process(_delta):
	var input_vec = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_vec.length() > 0:
		input_vec = input_vec.normalized()
		last_dir = input_vec


	# Use the CharacterBody2D `velocity` property and move via physics so collisions stop movement
	velocity = input_vec * speed

	# Move using move_and_collide; it returns collision info if we hit something
	var collision = move_and_collide(velocity * _delta)
	if collision:
		# Stop movement on collision so player cannot pass through
		velocity = Vector2.ZERO

	_update_animation(input_vec)


func _update_animation(input_vec: Vector2) -> void:
	if not anim:
		return

	var moving = input_vec.length() > 0

	# Determine dominant direction using last_dir for idle facing
	var dir = last_dir if not moving else input_vec
	var dominant = "side"
	if abs(dir.y) > abs(dir.x):
		dominant = "up" if dir.y < 0 else "down"
	else:
		dominant = "side"

	if moving:
		if dominant == "up":
			anim.animation = "b_run_up"
			anim.flip_h = false
		elif dominant == "down":
			anim.animation = "b_run_down"
			anim.flip_h = false
		else:
			anim.animation = "b_run_side"
			anim.flip_h = input_vec.x < 0
	else:
		if dominant == "up":
			anim.animation = "idle_upb"
			anim.flip_h = false
		elif dominant == "down":
			anim.animation = "idle_downb"
			anim.flip_h = false
		else:
			anim.animation = "idle_sideb"
			anim.flip_h = last_dir.x < 0

	if not anim.is_playing():
		anim.play()
