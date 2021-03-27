extends Sprite

export var nextLevel = 1
onready var nextGame = Global.getLevel(nextLevel)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Global.level = nextLevel
		Global.call_deferred("save_game")
		Global.Game = nextGame
		Global.call_deferred("changeLevel")
		Global.call_deferred("reloadHUD()")
		Global.call_deferred("_ready")



