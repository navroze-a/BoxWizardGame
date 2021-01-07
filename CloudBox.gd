extends RigidBody2D



func get_class(): return "CloudBox"
func is_class(name): return name == "CloudBox" 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_position_x(new_x):
	position.x = new_x
func set_position_y(new_y):
	position.y = new_y
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func negate_gravity():
	print("gravity negated") 
	gravity_scale = 0
func instate_gravity():
	print("gravity reinstated")
	gravity_scale = 0.2


