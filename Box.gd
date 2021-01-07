extends RigidBody2D

# BOX: Standard Box:
# mass: 8
# gravity scale: 11

func get_class(): return "Box"
func is_class(name): return name == "Box" 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_position_x(new_x):
	position.x = new_x
func set_position_y(new_y):
	position.y = new_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
