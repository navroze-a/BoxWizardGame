extends RigidBody2D


#var playerOnCloud = false

func get_class(): return "AngryCloudBox"
func is_class(name): return name == "AngryCloudBox" 

# Called when the node enters the scene tree for the first time.
func _ready():
	negate_gravity()
	pass # Replace with function body.

func set_position_x(new_x):
	position.x = new_x
func set_position_y(new_y):
	position.y = new_y
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if (playerOnCloud):
#		$CollisionShape2D.disabled = false
#	else:
#		$CollisionShape2D.disabled = true

func negate_gravity():
	print("gravity negated") 
	gravity_scale = 0
func instate_gravity():
	print("gravity reinstated")
	gravity_scale = 0




#func _on_Area2D_body_entered(body):
#	if (body.name == "Player"):
#		playerOnCloud = true


#func _on_Area2D_body_exited(body):
#	if (body.name == "Player"):
#		playerOnCloud = false
