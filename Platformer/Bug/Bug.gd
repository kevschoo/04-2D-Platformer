extends KinematicBody2D

var gravity = 1000
var damage = 10
var direction = 1


func _physics_process(_delta):
	var velocity = Vector2(100,0)
	velocity.x = 100 * direction
	velocity.y += gravity 
	move_and_slide(velocity)

func _on_Timer_timeout():
	direction *= -1

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Global.update_health(-damage)
		queue_free()


func _on_BugBox_body_entered(body):
	if body.name == "Player":
		queue_free()




