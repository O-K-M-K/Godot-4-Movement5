extends Node

class_name StateMachine

var _states_stack = []
var _states_map = {}
var _current_state : State
var velocity : Vector2

var user_input : Dictionary

@export var deafult_state_path : NodePath
@onready var default_state = get_node(deafult_state_path).name

@export var character_body_path : NodePath 
@onready var body = get_node(character_body_path)

func _ready():
	var childNodes = get_children()
	for child in childNodes:
		if child is State:
			add_state_to_map(child)
		else:
			push_error("StateMachine child " + child.name + " is not of class type: State")
	_states_stack.push_front(_states_map[default_state])
	_current_state = _states_stack[0]
	change_state(default_state)
	
	
func add_state_to_map(state: State):
	if(_states_map.has(state.name) == false):
		_states_map[state.name] = state
		if (state.connect("finished", change_state) == null):
			push_error(self.name + " failed to connect to state finished")
		return true
	else:
		push_error(state.name + " already exists in the state stack")
		return false

func change_state(state_name : String):
	if(_states_map.has(state_name)):
		if(_current_state != null):
			_current_state.exit()
		_current_state = _states_map[state_name]
		_current_state.enter(self)
	else:
		push_warning("StateMachine does not contain state " + state_name)

func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		"y": int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true
	}

func _physics_process(delta):
	body.velocity = velocity
	#user_input = get_input()
	_current_state.update(delta)
