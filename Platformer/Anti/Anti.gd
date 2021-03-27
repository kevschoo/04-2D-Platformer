extends KinematicBody2D

var gravity = -1000
var damage = 20
var direction = 1


func _physics_process(_delta):
	var velocity = Vector2(70,0)
	velocity.x = 70 * direction
	velocity.y = gravity 
	move_and_slide(velocity)
	if direction < 0 and not $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = false

func _on_Timer_timeout():
	direction *= -1
	

func _on_DamageBox_body_entered(body):
	if body.name == "Player":
		Global.update_health(-damage)

func _on_AntiBox_body_entered(body):
	if body.name == "Player":
		queue_free()

func _on_Timer2_timeout():
	gravity *= -1
	rotate(PI)
