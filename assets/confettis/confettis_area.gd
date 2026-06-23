## Pops confettis in a given radius
##
## ConfettisArea instantiates and triggers some [ConfettisParticles] emitters in
##  a random location within a provided radius. The amount of particles emitters
## and the radius in which they appear are both customizable.[br]
## The confettis don't trigger all at the same time, but in a staggered manner.
@icon("confettis_area.svg")
class_name ConfettisArea
extends Marker2D

const ConfettisParticlesScene := preload("confettis_particles.tscn")

## Emitted when all the confettis have been launched
signal finished

## Determines how many confettis emitters get popped
@export var confettis_amount := 5
## Determines a radius within which random confetti emitters will spawn
@export var confettis_radius := 128.0
## Determines the timing between different confetti emitter popping
@export var confettis_pop_time_delay := 0.5

var _time_elapsed := 0.0
var _confetti_left_to_spawn := 0


func _ready() -> void:
	set_process(false)


## Starts the process of spawning confetti at random places in an area around
## the node, over time. Once all confettis have been spawned, the [signal
## finished] signal is emitted.
func pop_confettis() -> void:
	_confetti_left_to_spawn = confettis_amount
	_time_elapsed = 0.0
	set_process(true)


func _process(delta: float) -> void:
	_time_elapsed += delta

	if _confetti_left_to_spawn > 0:
		# We still have confettis to spawn. Every time enough time passes since the
		# last spawn, we instantiate a new confetti emitter and save the remaining
		# time for the next cycle.
		if _time_elapsed < confettis_pop_time_delay:
			return
		_time_elapsed -= confettis_pop_time_delay
		_confetti_left_to_spawn -= 1
		_spawn_confetti()
		return

	# All confettis have been spawned. We wait one final delay before emitting
	# the finished signal, then we stop processing.
	if _time_elapsed < confettis_pop_time_delay:
		return

	set_process(false)
	finished.emit()


func _spawn_confetti() -> void:
	var confettis: ConfettisParticles = ConfettisParticlesScene.instantiate()
	confettis.global_position += Vector2.from_angle(randf() * TAU) * confettis_radius
	add_child(confettis)
