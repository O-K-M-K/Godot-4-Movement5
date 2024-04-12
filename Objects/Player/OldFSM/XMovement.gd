#extends 'res://Objects/Player/input.gd'
#
#
## Initialize the state. E.g. change the animation
#func enter(host):
	#_enter(host)
#
## Clean up the state. Reinitialize values like a timer
#func exit():
	#return
#
#func handle_input(event):
	#return
#
#func update(delta):
	#update_input(delta)
	#x_movement(delta)
#
#
#func x_movement(delta: float) -> void:
	##if currently_flying:
		##return
	#x_dir = user_input.x
	##is_moving = abs(x_dir)
	#var mult = 1
	#if is_jumping:
		#mult = in_air_x_mult
	#
	##if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		##return
	#var target_speed: float = x_dir * max_speed * mult
	#
	#var accelRate: float
	#if abs(target_speed) > 0.01:
		#accelRate = runAccelAmmount
	#else:
		#accelRate = runDeccelAmmount
	#
	#
	#
	#
	#var speedDif: float = target_speed - parent.velocity.x
	#var movement: float = speedDif * accelRate * delta
	#
	#if not parent.body.is_on_floor() and x_dir == 0:
		#parent.velocity.x = lerp(parent.velocity.x, parent.velocity.x + movement, 0.12)
	#else:
		#parent.velocity.x += movement
		#
	##set_direction(x_dir)
