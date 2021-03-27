extends Node

const SAVE_PATH = "user://savegame.sav"
const SECRET = "Rushed Game!"
var save_file = ConfigFile.new()
var level = 0
onready var HUD = get_node_or_null("/root/Game/UI/HUD")
onready var Coins = get_node_or_null("/root/Game/Coins")
onready var Bugs = get_node_or_null("/root/Game/Bugs")
onready var Antis = get_node_or_null("/root/Game/Antis")
onready var Game = getLevel(level)
onready var Coin = load("res://Coin/Coin.tscn")
onready var Bug = load("res://Bug/Bug.tscn")
onready var Anti = load("res://Anti/Anti.tscn")


var save_data = {
	"general": {
		"score":0
		,"health":100
		,"coins":[]
		,"bugs":[]	
		,"antis":[]	
	}
}
func changeLevel():
	if level == 0:
		Game = load("res://Game.tscn")
		get_tree().change_scene("res://Game.tscn")
	elif level == 1:
		Game = load("res://Game2.tscn")
		get_tree().change_scene("res://Game2.tscn")
		#call_deferred("load_game")
		
		
func getLevel(x):
	if x == 0:
		Game = load("res://Game.tscn")
	elif x == 1:
		Game = load("res://Game2.tscn")
	return Game

func reloadHUD():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	HUD.find_node("Level").text = "Level: " + str(level)
	Coins = get_node_or_null("/root/Game/Coins")
	Bugs = get_node_or_null("/root/Game/Bugs")
	Antis = get_node_or_null("/root/Game/Antis")
	
func _ready():
	update_score(0)
	update_health(0)
	getLevel(level)
	

func update_score(s):
	save_data["general"]["score"] += s
	reloadHUD()
	HUD.find_node("Score").text = "Score: " + str(save_data["general"]["score"])

func update_health(h):
	reloadHUD()
	save_data["general"]["health"] += h
	HUD.find_node("Health").text = "Health: " + str(save_data["general"]["health"])
	if save_data["general"]["health"] <= 0:
		var player = get_node_or_null("/root/Game/Player_Container/Player")
		player.die()
		save_data["general"]["score"] = -10
		save_data["general"]["health"] = 50
		update_health(0)
		update_score(0)

func restart_level():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	Coins = get_node_or_null("/root/Game/Coins")
	Bugs = get_node_or_null("/root/Game/Bugs")
	Antis = get_node_or_null("/root/Game/Antis")
	
	for c in Coins.get_children():
		c.queue_free()
	for b in Bugs.get_children():
		b.queue_free()
	for a in Antis.get_children():
		a.queue_free()
	for c in save_data["general"]["coins"]:
		var coin = Coin.instance()
		coin.position = str2var(c)
		Coins.add_child(coin)
	for b in save_data["general"]["bugs"]:
		var bug = Bug.instance()
		bug.position = str2var(b)
		Bugs.add_child(bug)
	for a in save_data["general"]["antis"]:
		var anti = Anti.instance()
		anti.position = str2var(a)
		Antis.add_child(anti)
	update_score(0)
	update_health(0)
	get_tree().paused = false

# ----------------------------------------------------------
	
func save_game():
	save_data["general"]["coins"] = []
	save_data["general"]["bugs"] = []
	for c in Coins.get_children():
		save_data["general"]["coins"].append(var2str(c.position))
	for b in Bugs.get_children():
		save_data["general"]["bugs"].append(var2str(b.position))
	for a in Antis.get_children():
		save_data["general"]["antis"].append(var2str(a.position))
	var save_game = File.new()
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, SECRET)
	save_game.store_string(to_json(save_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, SECRET)
	var contents = save_game.get_as_text()
	var result_json = JSON.parse(contents)
	if result_json.error == OK:
		save_data = result_json.result
	else:
		print("Error: ", result_json.error)
	save_game.close()
	
	var _scene = get_tree().change_scene_to(Game)
	getLevel(level)
	changeLevel()
	call_deferred("restart_level")
	print(level)
	
