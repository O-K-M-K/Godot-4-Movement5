extends StateMachine
@export var id : int = 1

var user_input : Dictionary

func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		"y": int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true,
		"spring" : Input.is_action_pressed("spring")
	}

func _ready():
	add_state('NORMAL')
	add_state("MOVEMENT")
	add_state('JUMP_SQUAT')
	add_state('SHORT_HOP')
	add_state('FULL_HOP')
	add_state('DASH')
	add_state('MOONWALK')
	add_state('WALK')
	add_state('CROUCH')
	call_deferred("set_state", states.NORMAL)
	

func state_logic(delta):
	user_input = get_input()
	parent.updateframes(delta)
	parent._physics_process(delta)
	

func get_transition(delta):
	#parent.move_and_slide() #parent.velocity*2,Vector2.ZERO,Vector2.UP
	#print(parent.states)
	parent.states.text = str(state)
	match state:
		states.NORMAL:
			parent.x_movement(delta, user_input)
			parent.jump_logic(delta, user_input)
			parent.apply_gravity(delta)
			
			
			#if int(Input.is_action_pressed("ui_right")) == 1:
				#parent.velocity.x = parent.RUNSPEED
				#parent.reset_frame()
				#parent.turn(false)
				#return states.DASH
			#if int(Input.is_action_pressed("ui_left")) == 1:
				#parent.velocity.x = -parent.RUNSPEED
				#parent.reset_frame()
				#parent.turn(true)
				#return states.DASH
			#if parent.velocity.x > 0 and state == states.STAND:
				#parent.velocity.x += -parent.TRACTION*1
				#parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
			#elif parent.velocity.x < 0 and state == states.STAND:
				#parent.velocity.x += parent.TRACTION*1
				#parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
		states.MOVEMENT:
			parent.x_movement(delta, user_input)
			if abs(user_input.x) != 1:
				parent.x_movement(delta, user_input)
				return states.NORMAL
			pass
		states.JUMP_SQUAT:
			pass
		states.SHORT_HOP:
			pass
		states.FULL_HOP:
			pass
		states.DASH:
			if Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent.reset_frame()
				parent.velocity.x = -parent.DASHSPEED
			elif Input.is_action_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent.frame()
				parent.velocity.x =parent.DASHSPEED
			else:
				if parent.frame >= parent.dash_duration-1:
					return states.STAND
							
		states.MOONWALK:
			pass
		states.WALK:
			pass
		states.CROUCH:
			pass
	parent.timers(delta)
	parent.move_and_slide()

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func state_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false
