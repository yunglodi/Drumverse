extends Node2D

@export var start_x = -10.0
@export var end_x = 880.0
@export var bpm = 120.0

var speed = 0.0

func _ready():
	global_position.x = start_x # Or position.x = start_x
	# IMPORTANT: Make sure you are NOT setting global_position.y or position.y here
	var beats_per_measure = 4
	var time_to_cross = (60.0 / bpm) * beats_per_measure
	speed = (end_x - start_x) / time_to_cross

func _process(delta):
	position.x += speed * delta
	# IMPORTANT: Make sure you are NOT setting position.y here
	if position.x >= end_x:
		position.x = start_x
