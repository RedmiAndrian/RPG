# Class name: Characters

# Giving an object some properties to set and get
var name
var health
var max_damage
var min_damage
var cric_damage
var sprite

# Initialise an object	
func _init(name, health, max_damage, min_damage, cric_damage, sprite):
	self.name = name
	self.health = health
	self.max_damage = max_damage
	self.min_damage = min_damage
	self.cric_damage = cric_damage
	self.sprite = sprite

# Setter and Getter for Health
func set_health(val):
	self.health = val
	
func get_health():
	return self.health
	
# Setter and Getter for the Range of damage
func set_damage(val1, val2):
	self.max_damage = val1
	self.min_damage = val2
	
func get_damage():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var final_damage = rng.randi_range(self.min_damage, self.max_damage)
	return final_damage
	
# Getter and Setter for Critical Damage
func set_cric_damage(val):
	self.cric_damage = val
	
func get_cric_damage():
	return self.cric_damage

# Getter and Setter for Sprite
func set_sprite(val):
	self.sprite = val

func get_sprite():
	return self.sprite
