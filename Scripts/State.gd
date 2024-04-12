extends Node
class_name State

signal finished(next_state_name)

var parent
# Initialize the state. E.g. change the animation
func _enter(host):
	parent = host
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	return

func _on_animation_finished(anim_name):
	return
