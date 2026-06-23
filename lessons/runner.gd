extends CharacterBody2D

@onready var _skin: Sprite2D = %Skin

const RUNNER_DOWN = preload("uid://c0i1ik45p7rhh")
const RUNNER_DOWN_LEFT = preload("uid://bork38ywg3paf")
const RUNNER_DOWN_RIGHT = preload("uid://cst3aklarj68")
const RUNNER_LEFT = preload("uid://bk7kvspkijqac")
const RUNNER_RIGHT = preload("uid://b4etxv4c5w1mq")
const RUNNER_UP = preload("uid://dtrvq16cx035")
const RUNNER_UP_LEFT = preload("uid://b5yil62vnj1o7")
const RUNNER_UP_RIGHT = preload("uid://c7x3s5c2r5l86")

const UP_LEFT = Vector2.UP + Vector2.LEFT
const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT

var max_speed := 600.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction_discrete := direction.sign()
	
	match direction_discrete:
		DOWN_RIGHT:
			_skin.texture = RUNNER_DOWN_RIGHT
		DOWN_LEFT:
			_skin.texture = RUNNER_DOWN_LEFT
		UP_LEFT:
			_skin.texture = RUNNER_UP_LEFT
		UP_RIGHT:
			_skin.texture = RUNNER_UP_RIGHT
		Vector2.DOWN:
			_skin.texture = RUNNER_DOWN
		Vector2.UP:
			_skin.texture = RUNNER_UP
		Vector2.LEFT:
			_skin.texture = RUNNER_LEFT
		Vector2.RIGHT:
			_skin.texture = RUNNER_RIGHT
	
	velocity = direction * max_speed
	move_and_slide()
	
