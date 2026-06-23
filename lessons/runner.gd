extends CharacterBody2D

@onready var _runner_visual: RunnerVisual = %RunnerVisualRed

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@export var run_threshold := 0.80

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	if direction.length() > 0.0:
		var current_speed_percent := velocity.length() / max_speed
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		if current_speed_percent > run_threshold:
			_runner_visual.animation_name = RunnerVisual.Animations.RUN
		else:	
			_runner_visual.animation_name = RunnerVisual.Animations.WALK
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
	move_and_slide()
	
