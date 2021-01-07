extends Node


export (PackedScene) var box
export (PackedScene) var cloudBox
export (PackedScene) var angryCloudBox
export (Array, PackedScene) var levelsList
export (PackedScene) var currLevel
var indexOfCurrLevel

const BOX_INDEX = 0
const CLOUDBOX_INDEX = 1
const ANGRY_CLOUDBOX_INDEX = 2



func _input(event):
	if (event.is_action_pressed("next_level")):
		# decide new index (cycle to it)
		indexOfCurrLevel += 1
		if (indexOfCurrLevel>= levelsList.size()):
			indexOfCurrLevel = 0
		
		# clear current level/setting of game
		for level in get_tree().get_nodes_in_group("Levels"):
			level.queue_free()
		delete_all_boxes()
		
		# make new level setup
		currLevel = levelsList[indexOfCurrLevel]
		add_level_as_child(currLevel.instance())
		reset_curr_level()


	if (event.is_action_pressed("choose_level_1")):
		pass

# Called when the node enters the scene tree for the first time.
func _ready():

	currLevel = levelsList[0]
	indexOfCurrLevel = 0
	add_level_as_child(currLevel.instance())




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



# Requires: instanceOfLevel = currLevel.instance()
func add_level_as_child(instanceOfLevel):
	add_child(instanceOfLevel)
	$Player.connect("fallen", instanceOfLevel, "_on_player_fallen")
	instanceOfLevel.connect("moving_camera_view", self, "delete_all_boxes")


func _on_Player_spawn_box(box_spawn_direction, box_type):
	var new_box
	if (box_type == "box"):
		new_box = box.instance()
		if (box_spawn_direction == Vector2(1,0)):
			var box_spawn_x = $Player.position.x + 80
			var box_spawn_y = $Player.position.y - 5 
			print ($Player.position.x , " ", box_spawn_x)
			print ($Player.position.y , " " , box_spawn_y)
			new_box.set_position_x(box_spawn_x)
			new_box.set_position_y(box_spawn_y)
			add_child(new_box)
		elif (box_spawn_direction == Vector2(-1,0)):
			var box_spawn_x = $Player.position.x - 80
			var box_spawn_y = $Player.position.y - 5 
			print ($Player.position.x , " ", box_spawn_x)
			print ($Player.position.y , " " , box_spawn_y)
			new_box.set_position_x(box_spawn_x)
			new_box.set_position_y(box_spawn_y)
			add_child(new_box)
	if (box_type == "cloudBox"):
		new_box = cloudBox.instance()
		if (box_spawn_direction == Vector2(1,-1)):
			var box_spawn_x = $Player.position.x + 80
			var box_spawn_y = $Player.position.y - 40
			print ($Player.position.x, " ", box_spawn_x)
			print ($Player.position.y, " ", box_spawn_y)
			new_box.set_position_x(box_spawn_x)
			new_box.set_position_y(box_spawn_y)
			add_child(new_box)
		elif (box_spawn_direction == Vector2(-1,-1)):
			var box_spawn_x = $Player.position.x - 80
			var box_spawn_y = $Player.position.y - 40
			print ($Player.position.x, " ", box_spawn_x)
			print ($Player.position.y, " ", box_spawn_y)
			new_box.set_position_x(box_spawn_x)
			new_box.set_position_y(box_spawn_y)
			add_child(new_box)
	if (box_type == "angryCloudBox"):
		new_box = angryCloudBox.instance()
		if (box_spawn_direction == Vector2(1,-1)):
			var box_spawn_x = $Player.position.x + 80
			var box_spawn_y = $Player.position.y + 40
			print ($Player.position.x, " ", box_spawn_x)
			print ($Player.position.y, " ", box_spawn_y)
			new_box.set_position_x(box_spawn_x)
			new_box.set_position_y(box_spawn_y)
			add_child(new_box)
		elif (box_spawn_direction == Vector2(-1,-1)):
			var box_spawn_x = $Player.position.x - 80
			var box_spawn_y = $Player.position.y + 40
			print ($Player.position.x, " ", box_spawn_x)
			print ($Player.position.y, " ", box_spawn_y)
			new_box.set_position_x(box_spawn_x)
			new_box.set_position_y(box_spawn_y)
			add_child(new_box)

func reset_curr_level():
	#deletes all levels and boxes
	for level in get_tree().get_nodes_in_group("Levels"):
		level.queue_free()
	delete_all_boxes()
	
	#reset curr level and move player to position
	add_level_as_child(currLevel.instance())
	$Player.start(Vector2(100,200))

func delete_all_boxes():
	for box in get_tree().get_nodes_in_group("Boxes"):
		box.queue_free()

func give_player_box(box_type):
	if (box_type == "box"):
		$Player.gainBoxPower(BOX_INDEX)
	elif (box_type == "cloudBox"):
		$Player.gainBoxPower(CLOUDBOX_INDEX)
	elif (box_type == "angryCloudBox"):
		$Player.gainBoxPower(ANGRY_CLOUDBOX_INDEX)


