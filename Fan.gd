extends Node2D

signal playerInFan(direction, strength, windLength)
signal boxInFan (box, direction, strength, windLength)
signal playerLeftFan (direction, strength, windLength)
signal boxLeftFan (box, direction, strength, windLength)

var direction
export (float) var strength
export (int) var windLength


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))
	if (windLength != 0):
		set_windLength(windLength)
	pass # Replace with function body.

func set_windLength(new_windLength):
	$FanWind/CollisionShape2D.shape.extents.y = new_windLength
	$FanWind.position.y = $FanBase.position.y - 5 - new_windLength
	$FanWind/AnimatedSprite.scale.x *= new_windLength
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func turn_off():
	$FanWind/AnimatedSprite.visible = false
	$FanWind/CollisionShape2D.disabled = true

func _on_FanWind_body_entered(body):
	if (body.name == "Player"):
		emit_signal("playerInFan", direction, strength, windLength)
	elif (body.is_in_group("Boxes")):
		emit_signal("boxInFan", body, direction, strength, windLength)


func _on_FanWind_body_exited(body):
	if (body.name == "Player"):
		emit_signal("playerLeftFan", direction, strength, windLength)
	elif (body.is_in_group("Boxes")):
		emit_signal("boxLeftFan", body, direction, strength, windLength)
