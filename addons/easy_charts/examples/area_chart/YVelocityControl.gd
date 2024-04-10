extends Control

@onready var chart: Chart = $VBoxContainer/Chart
@export var player_path : NodePath
@onready var Player := get_node(player_path)

# This Chart will plot 3 different functions
var f1: Function

var y_domain_lower
var y_domain_upper

func _ready():
	# Let's create our @x values
	#var x: Array = ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)
	var x: Array = [0]
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = [0]
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color.TRANSPARENT #Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color.BLACK
	cp.colors.ticks = Color.TRANSPARENT
	cp.colors.text = Color.TRANSPARENT
	cp.draw_bounding_box = true
	cp.title = ""
	cp.x_label = ""
	cp.y_label = ""
	cp.x_scale = 25
	cp.y_scale = 8
	cp.interactive = false # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	cp.show_x_label = false
	cp.show_y_label = false
	cp.smooth_domain = true
	cp.max_samples = 55
	
	y_domain_lower = Player.position.y * -1
	y_domain_upper = y_domain_lower + 300
	chart.set_y_domain(y_domain_lower, y_domain_upper)
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Pressure", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			color = Color("#3654eb"), 		# The color associated to this function
			marker = Function.Marker.NONE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be an Area Chart.
		}
	)
	
	# Now let's plot our data
	chart.plot([f1], cp)
	
	#Uncommenting the line below will show how real time data plotting works
	set_physics_process(true)


var new_val: float = 0
var time: float = 0

func _physics_process(delta: float):
	reset_y_domain()
	# This function updates the values of a function and then updates the plot
	time += delta/100
	new_val += time
	
	# we can use the `Function.add_point(x, y)` method to update a function
	f1.add_point(new_val, Player.position.y * -1)
	chart.queue_redraw() # This will force the Chart to be updated


func _on_CheckButton_pressed():
	set_physics_process(not is_physics_processing())

func reset_y_domain():
	if Player.position.y * -1 > y_domain_upper:
		y_domain_upper = Player.position.y * -1
		y_domain_lower = y_domain_upper + 300
		chart.set_y_domain(y_domain_lower, y_domain_upper)
	if Player.position.y *-1 < y_domain_lower:
		y_domain_lower = Player.position.y * -1
		y_domain_upper = y_domain_lower + 300
		chart.set_y_domain(y_domain_lower, y_domain_upper)
		
func _on_button_pressed() -> void:
	var lower = Player.position.y * -1
	var upper = lower + 300
	chart.set_y_domain(lower, upper)
