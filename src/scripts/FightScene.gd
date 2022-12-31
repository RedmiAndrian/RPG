# kinda like important classes and function that related to the node Node
extends Node

# Don't run two input key functions at the same time!!!!!!!

# Variable(s) initialisation
var Character = load("res://src/classes/character.gd")
var player_list # List of good guys
var enemy_list # List of bad guys
var option_list # List of options
var isPlayerTurn # Bool to check if it's player's turn
var isGoodCharacterTime # Bool to check if it's turn to choose good guys
var user_options # Bool to check if it's time for option/menu select
var option_selected # A variable (string) to state which option is selected
var selected_goodGuys # A variable (Characters) to state which good guys is selected
var selected_badGuys # A variable (Characters) to state which bad guys is selected
var isMenuLoaded # Bool to check if menu is loaded
var isAction = false # Bool to see if action is been done
var enter_pressed = false
var isAttack = false
onready var _init_index = 0 # An index variable for the getter of array
onready var goodGuys = get_node("goodGuys") # Referencing the goodGuys node (Node2D)
onready var badGuys = get_node("badGuys") # Referencing the badGuys node (Node3D)

# Debug: initialising option
var op1 = "Attack"
var op2 = "Heal"
var op3 = "Flee"

# DEBUG: initialising good guys
var player1 = Character.new("Knight1", 40, 7, 5, 15, "res://src/assets/goodGuys.png")
var player2 = Character.new("Knight2", 40, 7, 5, 15, "res://src/assets/goodGuys.png")

# DEBUG: initialising bad guys
var enemy1 = Character.new("Monster1", 18, 5, 3, 15, "res://src/assets/badGuys.png")
var enemy2 = Character.new("Monster2", 18, 6, 4, 15, "res://src/assets/badGuys.png")



# Function for keypresses: Choose which enemy and which player
func get_input_for_cursor_choosing_characters(player_num, enemy_num, _choose_goodGuys):
	user_options = false
	if Input.is_action_just_pressed("ui_left") and !user_options:
		# If it's time to choose good guys
		if _choose_goodGuys:
			if _init_index - 1 >= 0:
				_init_index = _init_index - 1
			else:
				_init_index = player_num - 1
			_deploy_cursor(get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().x, get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().y)
		
		# If it's time to choose bad guys
		if !_choose_goodGuys:
			print_debug("clicked")
			if _init_index - 1 >= 0:
				_init_index = _init_index - 1
			else:
				_init_index = enemy_num - 1
			_deploy_cursor(get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().x, get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().y)

	if Input.is_action_just_pressed("ui_right") and !user_options:
		# If it's time to choose good guys
		if _choose_goodGuys:
			if _init_index + 1 < player_num:
				_init_index = _init_index + 1
			else:
				_init_index = 0
			_deploy_cursor(get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().x, get_node("goodGuys/goodGuys_" + str(_init_index + 1)).get_position().y)
		
		# If it's time to choose badguys
		if !_choose_goodGuys:
			print_debug("clicked")
			if _init_index + 1 < enemy_num:
				_init_index = _init_index + 1
			else:
				_init_index = 0
			_deploy_cursor(get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().x, get_node("badGuys/badGuys_" + str(_init_index + 1)).get_position().y)
	
	if Input.is_action_just_pressed("ui_accept") and _choose_goodGuys:
		selected_goodGuys = player_list[_init_index]
		_init_index = 0
		user_options = true
		_destroy_cursor()
		isGoodCharacterTime = !_choose_goodGuys
	elif Input.is_action_just_pressed("ui_accept") and (!_choose_goodGuys and isAction):
		print_debug("chosen bad guys")
		selected_badGuys = enemy_list[_init_index]
		_init_index = 0
		user_options = true
		_destroy_cursor()
		isGoodCharacterTime = !_choose_goodGuys

# Function to deploy cursor to the scene to the desired position
func _deploy_cursor(x, y):
	_destroy_cursor()
	var _cursor = Sprite.new()
	_cursor.texture = load("res://src/assets/cursor.png")
	_cursor.name = "_cursor"
	_cursor.set_position(Vector2(x, y))
	add_child(_cursor)

# Function to load options
func load_option(options):
	for i in range(1, len(option_list) + 1):
		get_node("hud/label_" + str(i)).text = option_list[i - 1]

# Function to deploy menu_cursor
func _deploy_menu_cursor(x, y):
	_destroy_menu_cursor()
	var _menu_cursor = Sprite.new()
	_menu_cursor.texture = load("res://src/assets/menu_cursor.png")
	_menu_cursor.name = "_menu_cursor"
	_menu_cursor.set_position(Vector2(x, y))
	add_child(_menu_cursor)

# Function to destroy menu cursor
func _destroy_menu_cursor():
	if get_node_or_null("_menu_cursor") != null:
		remove_child(get_node("_menu_cursor"))

# Function for getting input for choosing options in the menu
func get_input_for_menu():
	# Code for managing menu cursor
	if Input.is_action_just_pressed("ui_left") and !isAction:
		if _init_index - 1 >= 0:
			_init_index = _init_index - 1
		else:
			_init_index = len(option_list) - 1
		_deploy_menu_cursor(get_node("hud/label_" + str(_init_index + 1)).rect_position.x, get_node("hud/label_" + str(_init_index + 1)).rect_position.y)
	if Input.is_action_just_pressed("ui_right") and !isAction:
		if _init_index + 1 < len(option_list):
			_init_index = _init_index + 1
		else:
			_init_index = 0
		_deploy_menu_cursor(get_node("hud/label_" + str(_init_index + 1)).rect_position.x, get_node("hud/label_" + str(_init_index + 1)).rect_position.y)
	
	if Input.is_action_just_pressed("ui_accept") and (!isAction and get_node_or_null("_menu_cursor") != null):
		enter_pressed = true
		_destroy_menu_cursor()
		option_selected = option_list[_init_index]

		if option_selected == "Attack":
			print_debug("Attack")
			isAttack = true
			isAction = true
		if option_selected == "Heal":
			_heal(selected_goodGuys)
		if option_selected == "Flee":
			_flee()

# Function to attack
func _attack(player):
	get_input_for_cursor_choosing_characters(len(player_list), len(player_list), isGoodCharacterTime)
	if selected_badGuys != null:
		selected_badGuys.set_health(selected_badGuys.get_health() - player.get_damage())
		isAction = false
		isGoodCharacterTime = true
		user_options = false
		isPlayerTurn = false
		print_debug(selected_badGuys.get_health())
		selected_badGuys = null
		selected_goodGuys = null

# Function to heal
func _heal(player):
	pass
	isAction = false
	isGoodCharacterTime = true
	user_options = false
	selected_badGuys = null
	selected_goodGuys = null

# Function to flee
func _flee():
	pass

# Function of what to do after player choosing character
func menu_select():
	if !isMenuLoaded:
		load_option(option_list)
	
	if isAction:
		if isAttack:
			_attack(selected_goodGuys)
	else:
		get_input_for_menu()



# Function of what to do during player's turn
func _isPlayerTurnFunc():
	if !user_options:
		get_input_for_cursor_choosing_characters(len(player_list), len(enemy_list), isGoodCharacterTime)
	if user_options:
		menu_select()

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
	user_options = false
	isPlayerTurn = true
	isGoodCharacterTime = true
	player_list = [player1, player2]
	enemy_list = [enemy1, enemy2]
	option_list = [op1, op2, op3]
	_load_characters()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPlayerTurn:
		_isPlayerTurnFunc()
