extends KinematicBody2D


signal fallen
signal impaled
signal beat_level
signal reset_level

signal spawn_box(box_spawn_direction, curr_box_type)
signal cycled_box_type
signal changed_box_power



var input_direction = 0 # -1 is left, 0 is neutral, 1 is right
var direction = 1 # will never acc be 0 when running the code, only -1 left or 1 right

var speed_x = 0 #pixels/second #just magnitude, not vector
var speed_y = 0
var velocity = Vector2()

export (int, 0, 200) var PUSH = 75 #player's inertia
export (float, 0, 1) var PUSH_FACTOR = 0.4

const MAX_SPEED_X = 350
const MAX_AIR_SPEED_x = 250
const HORIZONTAL_ACCELERATION = 600
const HORIZONTAL_DECELERATION = 1000


const JUMP_FORCE = 320
const GRAVITY_BACKUP = 500
var GRAVITY = 500
const UP = Vector2(0,-1)

var gravityDirection = Vector2(0, 1)


var screen_size
var alive = true

const BOX_INDEX = 0
const CLOUDBOX_INDEX = 1

export (Array, String) var box_powers = ["box", "cloudBox", "angryCloudBox"]
export (int) var curr_box_type_index
export (String) var curr_box_type

export (Array, int) var num_box_power_left = [0,0,0]


# Called when the node enters the scene tree for the first time.
func _ready():
	$playerCollision.disabled = true
	set_physics_process(true)
	set_process_input(true)
	screen_size = get_viewport_rect().size
	hide()
	start(Vector2(50,200))
	
	curr_box_type_index = 0
	curr_box_type = box_powers[curr_box_type_index]


func _input(event):
	if (event.is_action_pressed("retry")):
		emit_signal("reset_level")


	if (event.is_action_pressed("jump") && is_on_floor()):
		speed_y = -JUMP_FORCE #we go negative so that it'll be a negative y, so we'll go up in the game


	if (event.is_action_pressed("make_box")):
		if (capableOfMakingBox(curr_box_type_index)):
			var box_location = determine_box_location()
			print(box_location)
			if box_location: #if box_location is not false
				emit_signal ("spawn_box",box_location, curr_box_type)
				num_box_power_left[curr_box_type_index] -= 1
		else:
			pass #play error sound


	if (event.is_action_pressed("cycle_box_type")):
		cycle_box_type()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	## HORIZONTAL INPUTS
	
	if input_direction: #dont wanna change prev direction if hes currently unmoving
		direction = input_direction
	
	# Getting input
	if Input.is_action_pressed("move_left"):
		input_direction = -1
	elif Input.is_action_pressed("move_right"):
		input_direction = 1
	else:
		input_direction = 0
	
	## HORIZONTAL MOVEMENT CALCS
	
	#if new direction is opposite from prev direction, we drecrease speed_x so that we 
	# dont conserve it all changing direction (if we dont do this, change directions will be 
	# much more weird as we jerk cuz we saved speed_x)
	if (direction ==  -1*input_direction): 
		speed_x /= 2.5
	
	if input_direction: #means if direction is not 0
		speed_x += HORIZONTAL_ACCELERATION*delta
	else:
		speed_x -= HORIZONTAL_DECELERATION*delta
	
	if (.is_on_floor()):
		speed_x = clamp(speed_x, 0, MAX_SPEED_X) #so that we dont get negative speed, or infinite speed
	else:
		speed_x = clamp(speed_x,0,MAX_AIR_SPEED_x)
	
	velocity.x = speed_x *  direction #use prev direction, not new input so that movement is smoother
	
	# incorporate gravity to our vertical speed each frame
	speed_y += GRAVITY*delta
	
	velocity.y = speed_y
	
	
 #move_and_slide already accounts for delta so no need to multiply velocity by delta
	move_and_slide(velocity, UP, false, 4, PI/4, false)
	
	
	# after calling move_and_slide()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Boxes") && !(collision.collider.is_class("AngryCloudBox")):
			collision.collider.apply_central_impulse(-collision.normal * velocity.length() * PUSH_FACTOR)
	# made adjustments to make box interaction worksee: http://kidscancode.org/godot_recipes/physics/kinematic_to_rigidbody/
	
	
	
	# CHECK PLAYER STATES (i.e if fallen, if beaten level, etc.)
	check_if_fallen() # check if fallen
	
	if (position.x > screen_size.x):
		emit_signal("beat_level")
	
	
	
	# CHANGE ANIMATION STATE: 
	
	#############################****** ANIMATION CREDS: @SCISSORMARKS
	$AnimatedSprite.play()

	if (direction == 1):
		$AnimatedSprite.flip_h = false
	elif (direction == -1):
		$AnimatedSprite.flip_h = true
	
	if input_direction:
		$AnimatedSprite.animation= "walk"
	else:
		$AnimatedSprite.animation = "idle"
	
	


#func _process(delta):
#	if (.is_on_floor()):
#		print ("Player is on a ground now!")
#	else:
#		print ("Player is in air now!")

func capableOfMakingBox(boxIndex):
	return (num_box_power_left[boxIndex] > 0)

func gainBoxPower(boxIndex):
	num_box_power_left[boxIndex] += 1
	emit_signal("changed_box_power")

func cycle_box_type():
	curr_box_type_index += 1
	if (curr_box_type_index >= box_powers.size()):
		curr_box_type_index = 0
	
	curr_box_type = box_powers[curr_box_type_index]
	emit_signal("cycled_box_type")

# Produces a normalized vector in one of the 8 cardinal directions(indiating free position for box to be made)
# if none are free, produces (0,0). Also, if one of the spots is free, it prioritizes in the following order:
# First: is below feet free?, then, is (input_direction,-1) free?, then is (input_direction,0) free?, then is (input_direction, 1) free? 
func determine_box_location():
	if (curr_box_type == "box"):
		if (direction == 1):
			return (Vector2(1,0))
		elif (direction == -1):
			return(Vector2(-1,0))
	elif (curr_box_type == "cloudBox"):
		if (direction == 1):
			return(Vector2(1,-1))
		elif (direction == -1):
			return (Vector2(-1,-1))
	elif (curr_box_type == "angryCloudBox"):
		if (direction == 1):
			return(Vector2(1,-1))
		elif (direction == -1):
			return (Vector2(-1,-1))

func check_if_fallen():
	if (position.y > screen_size.y + 50):
		alive = false
		emit_signal("fallen")

#func check_if_below(object):
#	if (position.y > object.position.y):
#		emit_signal("fallen")
		
func start(position):
	alive = true
	self.position = position
	# resets num of boxes to 0
	for index in range(num_box_power_left.size()):
		print(index)
		num_box_power_left[index] = 1 ################################################### set to 1 for debug rn
		print("changed ", box_powers[index] , " power to 0")
	emit_signal("changed_box_power")
	show()
	$playerCollision.disabled = false
	
func impale():
	alive = false
	$playerCollision.disabled = true
	visible = false
	emit_signal("fallen") #PLACEHOLDER, SHOULD MAKE IT IMPALED OR SMTH SPECIFIC LATER
