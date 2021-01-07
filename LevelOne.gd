extends Node2D

signal moving_camera_view


var secondScreenReached = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# check if at border
	var SCREEN_SHIFT_THRESHOLD = 0
	
	if (get_node('../Player').position.x >= get_viewport().size.x - SCREEN_SHIFT_THRESHOLD): #if at right border of screen
		$'../Player'.position.x -= (get_viewport().size.x-SCREEN_SHIFT_THRESHOLD)
		$LevelTiling.position.x -= (get_viewport().size.x-SCREEN_SHIFT_THRESHOLD)
		$LevelSpecificText.rect_position.x -= (get_viewport().size.x-SCREEN_SHIFT_THRESHOLD)
		$Powerups.position.x -= (get_viewport().size.x-SCREEN_SHIFT_THRESHOLD)
		emit_signal("moving_camera_view")

	elif ($'../Player'.position.x <= SCREEN_SHIFT_THRESHOLD): #if at left border of screen
		$'../Player'.position.x += (get_viewport().size.x - SCREEN_SHIFT_THRESHOLD)
		$LevelTiling.position.x += (get_viewport().size.x - SCREEN_SHIFT_THRESHOLD)
		$LevelSpecificText.rect_position.x += (get_viewport().size.x-SCREEN_SHIFT_THRESHOLD)
		$Powerups.position.x += (get_viewport().size.x-SCREEN_SHIFT_THRESHOLD)
		emit_signal("moving_camera_view")
		




# CHECKING PLAYER STATE METHODS: 

func _on_player_fallen():
	$deathMsg.show()
	
func _on_FinishFlag_flagReached(body):
	$levelCompleteMsg.show()

# POWERUP COLLECTION METHODS:

func _on_boxPowerUp_collected(body):
	if (body.name == "Player"):
		$'../Player'.gainBoxPower($'..'.BOX_INDEX)




func _on_cloudBoxPowerUp_collected(body):
	if (body.name == "Player"):
		$'../Player'.gainBoxPower($'..'.CLOUDBOX_INDEX)


func _on_Spike_body_entered(body):
	if (body.name == "Player"):
		body.impale()

func _on_Fan_boxInFan(box, direction, strength, windLength):
	if (box.is_class("Box")):
		print(box.get_class(), " entered the Fan Wind")
	elif (box.is_class("CloudBox")):
		print(box.get_class(), " entered the Fan Wind")
		box.set_applied_force(-box.get_linear_velocity())
		box.negate_gravity()
		box.add_central_force(direction*strength)
	elif (box.is_class("AngryCloudBox")):
		box.set_applied_force(-box.get_linear_velocity())
		box.negate_gravity()
		box.add_central_force(direction*strength)


func _on_Fan_boxLeftFan(box, direction, strength, windLength):
	if (box.is_class("Box")):
		print(box.get_class(), " exited the Fan Wind")
	elif (box.is_class("CloudBox")):
		print(box.get_class(), " exited the Fan Wind")
		box.set_applied_force(Vector2(0,0))
		box.instate_gravity()
	elif (box.is_class("AngryCloudBox")):
		print(box.get_class(), " exited the Fan Wind")
		box.set_applied_force(Vector2(0,0))
		box.set_linear_velocity(Vector2(0,0))
		box.instate_gravity()
