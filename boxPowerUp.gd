extends Area2D


signal collected(body)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_boxPowerUp_body_entered(body):
	if (body.name == "Player"):
		emit_signal("collected", body)
		$CollisionShape2D.set_deferred("disabled", true) #Disable model so we dont trigger hit signal more than once
		hide() # Body disappears on hit
		queue_free()
