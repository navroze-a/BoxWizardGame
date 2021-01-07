extends CanvasLayer


export(Array, Texture) var boxTextureFilePaths = [load("res://Assets/Free/Items/Boxes/Box3/Idle.png"),  
												  load("res://Assets/Free/MarioCloud.png"),
												load("res://Assets/Free/AngryMarioCloud.png")]
var currBoxIndexDisplayed


# Called when the node enters the scene tree for the first time.
func _ready():
	currBoxIndexDisplayed = 0
	$CurrentBoxDisplay.texture = boxTextureFilePaths[currBoxIndexDisplayed]
	$CurrentBoxCount.text =str($'../Player'.num_box_power_left[$'../Player'.curr_box_type_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_cycled_box_type():
	currBoxIndexDisplayed += 1
	if (currBoxIndexDisplayed >= boxTextureFilePaths.size()):
		currBoxIndexDisplayed = 0
	
	$CurrentBoxDisplay.texture = boxTextureFilePaths[currBoxIndexDisplayed]
	$CurrentBoxCount.text = str($'../Player'.num_box_power_left[$'../Player'.curr_box_type_index])


func _on_Player_spawn_box(box_spawn_direction, curr_box_type):
	$CurrentBoxCount.text = str($'../Player'.num_box_power_left[$'../Player'.curr_box_type_index] - 1)


func _on_Player_changed_box_power():
	$CurrentBoxCount.text = str($'../Player'.num_box_power_left[$'../Player'.curr_box_type_index])
