extends CharacterBody2D

var _velocity = Vector2(0,0)
var dash_duration = 10

var RUNSPEED = 340
var DASHSPEED = 390
var WALKSPEED = 200
var GRAVITY = 1800
var JUMPFORCE = 500
var MAX_JUMPFORCE = 800
var DOUBLEJUMPFORCE = 1000
var MAXAIRSPEED = 300
var AIR_ACCEL = 25
var FALLSPEED = 60
var FALLINGSPEED = 900
var MAXFALLSPEED = 900
var TRACTION = 40
var ROLL_DISTANCE = 350
var air_dodge_speed = 500
var UP_B_LAUNCHSPEED = 700


# BASIC MOVEMENT VARAIABLES ---------------- #
var face_direction := 1
var x_dir := 1

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

@export_group("", "")
# ------------------------------------------ #

# GRAVITY ----- #
@export var gravity_acceleration : float = 3840
@export var gravity_max : float = 1020
# ------------- #

# JUMP VARAIABLES ------------------- #
@export var jump_force : float = 1400
@export var jump_cut : float = 0.25
@export var jump_gravity_max : float = 500
@export var jump_hang_treshold : float = 2.0
@export var jump_hang_gravity_mult : float = 0.1
# Timers
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
# ----------------------------------- #


@export_group("Spring Movement")
@export var spring_velocity : float = 0.0 #velocity
##In Hz
@export var oscillation_frequency : float = 4
@onready var omega = 2*PI*oscillation_frequency

##How springy do you want the spring to be. Lower = more springy
@export_range(0, 100, 0.1, "suffix:%") var percentage_decrease : float = 95
##How long to spring - kinda proportional with time
@export var pd_frequency : float = 0.5

@onready var actual_decrease = 1-(percentage_decrease/100)
@onready var zeta = log(actual_decrease)/(omega*-1*pd_frequency)

@onready var init_x = float(global_position.x)

@export_group("", "")

@onready var states = $State

var frame = 0
func updateframes(delta):
	frame += 1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	#$Sprite.set_flip_h(direction)

func reset_frame():
	frame = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _physics_process(delta):
	pass
	#$Frames.text = str(frame)

func x_movement(delta: float, user_input) -> void:
	#if currently_flying:
		#return
	x_dir = user_input.x
	#is_moving = abs(x_dir)
	var mult = 1
	if is_jumping:
		mult = in_air_x_mult
	
	#if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		#return
	var target_speed: float = x_dir * max_speed * mult
	
	var accelRate: float
	if abs(target_speed) > 0.01:
		accelRate = runAccelAmmount
	else:
		accelRate = runDeccelAmmount
	
	var speedDif: float = target_speed - velocity.x
	var movement: float = speedDif * accelRate * delta
	
	if not is_on_floor() and x_dir == 0:
		velocity.x = lerp(velocity.x, velocity.x + movement, 0.12)
	else:
		velocity.x += movement


func jump_logic(_delta: float, user_input) -> void:
	# Reset our jump requirements
	if is_on_floor():
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if user_input["just_jump"]:
		jump_buffer_timer = jump_buffer
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
		
		velocity.y = -jump_force
	
	# We're not actually interested in checking if the player is holding the jump button
	#if user_input["jump"]:pass
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling
	if user_input["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)
	
	# This way we won't start slowly descending / floating once hit a ceiling
	# The value added to the treshold is arbritary,
	# But it solves a problem where jumping into 
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 100.0

func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return
	
	# Normal gravity limit
	if velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity



func timers(delta: float) -> void:
	# Using timer nodes here would mean unnececary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta
