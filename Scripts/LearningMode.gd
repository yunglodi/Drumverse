extends Node2D

@export var repeat_button : Button  # Reference to the repeat button
@onready var moving_circle : Node2D = $MovingCircle  # Reference to the moving circle
@onready var note_hit_status : Array = []  # Array to track notes hit status (if needed)
@onready var animation_player : AnimationPlayer = $DemoAnimator  # Reference to the animation player
@onready var hit_effect : PackedScene = preload("res://scenes/shared/HitEffect.tscn")  # Packed scene for hit effect

var has_moved : bool = false  # Whether the circle has moved
var hit_threshold : float = 100  # Threshold for hitting notes (adjust as needed)

# Called when the scene is ready
func _ready():
	if repeat_button == null:
		print("Error: repeat_button is not assigned!")
	else:
		print("Repeat button assigned, connecting signal.")
		repeat_button.connect("pressed", Callable(self, "_on_repeat_button_pressed"))

# Function to handle repeat button press
func _on_repeat_button_pressed():
	print("Repeat button pressed, resetting the movement.")
	reset_demo()

# Function to reset the demo (move circle back to start and clear hit status)
func reset_demo():
	has_moved = false
	moving_circle.position.x = 0  # Reset position of the circle
	note_hit_status.clear()  # Reset notes hit status (if you are tracking hits)

	# Restart animation and demo logic
	animation_player.play("move_animation")  # Assuming you have a move animation for the circle

	# Start the movement
	start_moving_circle()

# Function to start moving the circle
func start_moving_circle():
	if has_moved:
		return  # Only move once per demo run
	has_moved = true

	# Logic to move the circle from left to right
	var move_duration : float = 3.0  # Duration for the circle to move (adjust as needed)
	var target_position : Vector2 = Vector2(800, moving_circle.position.y)  # Target position

	# Create an animation for the circle movement
	var animation = Animation.new()
	animation.length = move_duration
	animation.track_insert_key(0, 0.0, moving_circle.position)  # Starting position
	animation.track_insert_key(0, move_duration, target_position)  # Target position after moving

	# Add the animation to the animation player and play it
	animation_player.add_animation("move_animation", animation)
	animation_player.play("move_animation")

	# Optionally, check if the moving circle hits a note at the target position
	check_for_hits(target_position)

# Function to check if the moving circle hits any notes
func check_for_hits(target_position: Vector2):
	for note in get_node("NotesContainer").get_children():
		if note is Node2D and note.position.distance_to(target_position) < hit_threshold:
			# Play hit effect when the circle reaches the note
			show_hit_effect(note.position)
			break  # Only hit once per movement

# Function to show the hit effect at the note position
@warning_ignore("shadowed_variable_base_class")
func show_hit_effect(position: Vector2):
	var effect_instance = hit_effect.instantiate()
	add_child(effect_instance)
	effect_instance.position = position
	effect_instance.play("hit_effect_animation")  # Assuming you have an animation for the hit effect
