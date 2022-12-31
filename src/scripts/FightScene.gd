extends Node

# Variable(s) initialisation
var Character = load("res://src/classes/character.gd")
var player_list
var enemy_list
var isPlayerTurn
var isGoodCharacterTime
onready var _init_index = 0
onready var goodGuys = get_node("goodGuys")
onready var badGuys = get_node("badGuys")


# DEBUG: initialising good guys
var player1 = Character.new("Knight1", 40, 7, 5, 15, "res://src/assets/goodGuys.png")
var player2 = Character.new("Knight2", 40, 7, 5, 15, "res://src/assets/goodGuys.png")

# DEBUG: initialising bad guys
var enemy1 = Character.new("Monster1", 18, 5, 3, 15, "res://src/assets/badGuys.png")
var enemy2 = Character.new("Monster2", 18, 6, 4, 15, "res://src/assets/badGuys.png")



# Function for keypresses: Choose which enemy and which player
func get_input_for_cursor_choosing_characters(player_num, enemy_num, _choose_goodGuys):
	if Input.is_action_just_pressed("ui_left"):
		# If it's time to choose good guys
		if _choose_goodGuys:
			if _init_index - 1 >= 0:
				_init_index = _init_index - 1
			else:
				_init_index = player_num - 1
			_deploy_cursor(get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().x, get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().y)
		
		# If it's time to choose bad guys
		if not _choose_goodGuys:
			if _init_index - 1 >= 0:
				_init_index = _init_index - 1
			else:
				_init_index = enemy_num - 1
			_deploy_cursor(get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().x, get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().y)

	if Input.is_action_just_pressed("ui_right"):
		# If it's time to choose good guys
		if _choose_goodGuys:
			if _init_index + 1 < player_num:
				_init_index = _init_index + 1
			else:
				_init_index = 0
			_deploy_cursor(get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().x, get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().y)
		
		# If it's time to choose badguys
		if not _choose_goodGuys:
			if _init_index + 1 < enemy_num:
				_init_index = _init_index + 1
			else:
				_init_index = 0
			_deploy_cursor(get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().x, get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().y)


# Function to deploy cursor to the scene to the desired position
func _deploy_cursor(x, y):
	_destroy_cursor()
	var _cursor = Sprite.new()
	_cursor.texture = load("res://src/assets/cursor.png")
	_cursor.name = "_cursor"
	_cursor.set_position(Vector2(x, y))
	add_child(_cursor)

# Function of what to do during player's turn
func _isPlayerTurnFunc():
	get_input_for_cursor_choosing_characters(len(player_list), len(enemy_list), isGoodCharacterTime)

# TODO: Function for an AI to do
func _ai():
	pass

# Function to switch between choosing good guys or bad guys
func _switcher():
	isGoodCharacterTime = !isGoodCharacterTime

# Function to remove/destroy cursor from the scene
func _destroy_cursor():
	if get_node_or_null("_cursor") != null:
		remove_child(get_node("_cursor"))

# Function to be called to load all characters to screen
func _load_characters():
	# Loading good guys
	for i in range(1, len(player_list) + 1):
		var ps = goodGuys.get_node("goodGuys_" + str(i))
		ps.texture = load(player_list[i - 1].get_sprite())
	
	# Loading bad guys
	for i in range(1, len(enemy_list) + 1):
		var es = badGuys.get_node("badGuys_" + str(i))
		es.texture = load(enemy_list[i - 1].get_sprite())

# Called when the node enters the scene tree for the first time.
func _ready():
	# DEBUG initialising an array of good guys and bad guys
	isPlayerTurn = true
	isGoodCharacterTime = true
	player_list = [player1, player2]
	enemy_list = [enemy1, enemy2]
	_load_characters()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPlayerTurn:
		_isPlayerTurnFunc()
