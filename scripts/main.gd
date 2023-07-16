extends Node

@export var creature_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$CreatureTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	get_tree().call_group("creatures", "queue_free")
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("¡Prepárate!")


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_creature_timer_timeout():
	# Create a new instance of the Creature scene.
	var creature = creature_scene.instantiate()

	# Choose a random location on Path2D.
	var creature_spawn_location = get_node("CreaturePath/CreatureSpawnLocation")
	creature_spawn_location.progress_ratio = randf()

	# Set the creature's direction perpendicular to the path direction.
	var direction = creature_spawn_location.rotation + PI / 2

	# Set the creature's position to a random location.
	creature.position = creature_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	creature.rotation = direction

	# Choose the velocity for the creature.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	creature.linear_velocity = velocity.rotated(direction)

	# Spawn the creature by adding it to the Main scene.
	add_child(creature)


func _on_start_timer_timeout():
	$CreatureTimer.start()
	$ScoreTimer.start()
