class_name Runner
extends CharacterBody2D

@onready var _runner_visual: RunnerVisual = %RunnerVisualRed
@onready var _dust: GPUParticles2D = %Dust

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@export var run_threshold := 0.80

signal walked_to

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
			_dust.emitting = true
		else:	
			_runner_visual.animation_name = RunnerVisual.Animations.WALK
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
	move_and_slide()
	
func walk_to(destination_global_position: Vector2) -> void:
	var direction := global_position.direction_to(destination_global_position)
	_runner_visual.angle = direction.orthogonal().angle()
	_runner_visual.animation_name = RunnerVisual.Animations.WALK
	_dust.emitting = true

	var distance := global_position.distance_to(destination_global_position)	
	var duration :=  distance / (max_speed * 0.2)
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func():
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
		walked_to.emit()
	)
	
	
