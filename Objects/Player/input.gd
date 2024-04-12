extends State


var user_input : Dictionary

@export_group("X Movement")
##Speed is in px/s
@export var max_speed: float = 600
@export var acceleration: float = 3000
@export var turning_acceleration : float = 13500
@export var deceleration: float = 3200
@export var crouch_speed: float = 100
@export var in_air_x_mult: float = 1.042
@onready var runAccelAmmount: float = (60 * 500)/max_speed
@onready var runDeccelAmmount: float = (60 * 500)/max_speed
var x_dir := 1
var is_jumping := false

# All iputs we want to keep track of
func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		"y": int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true
	}


func update_input(delta):
	user_input = get_input()

# Clean up the state. Reinitialize values like a timer
func exit():
	return
