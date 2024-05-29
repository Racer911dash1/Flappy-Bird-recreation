extends Node2D

const PIPES = preload("res://Main/pipes.tscn")

@onready var point_counter_label: Label = $CanvasLayer/PointCounterLabel
@onready var pipe_spawn_timer: Timer = $PipeSpawnTimer
@onready var front_sprite_2d: Sprite2D = $CanvasLayer/FrontSprite2D
@onready var hit_color_rect: ColorRect = $CanvasLayer/HitColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gameover: Sprite2D = $CanvasLayer/Gameover
@onready var background_2d: Sprite2D = $Background2D
@onready var floor_sprite_2d: Sprite2D = $BottomWorldBoundary/FloorSprite2D

@export var pipe_spawn_height : float = 0
@export var background_sprites : Array = []

var pipes_passed : int = 0
var timer_started : bool = false
var reload_scene : bool = false

func _ready() -> void:
	hit_color_rect.hide()
	animation_player.play("Flappy_Intro_Up_Down")
	var random_background = background_sprites.pick_random()
	background_2d.texture = random_background 

func _physics_process(delta: float) -> void:
	move_floor(delta)
	jump()

func _on_pipe_spawn_timer_timeout() -> void:
	var instance = PIPES.instantiate()
	instance.global_position = Vector2(get_viewport_rect().size.x + 100, randf_range(pipe_spawn_height, get_viewport_rect().size.y - pipe_spawn_height - 100))
	add_child(instance)

func _on_flappy_pipe_passed() -> void:
	pipes_passed += 1
	point_counter_label.text = str(pipes_passed)

func _on_flappy_hit() -> void:
	hit_color_rect.show()
	animation_player.play("HitEffect")
	await get_tree().create_timer(1).timeout
	gameover.show()
	timer_started = false
	reload_scene = true
	
func jump():
	if Input.is_action_just_pressed("jump") and timer_started == false:
		timer_started = true
		front_sprite_2d.hide()
		pipe_spawn_timer.start()
		animation_player.stop()
		if reload_scene == true:
			get_tree().reload_current_scene()
			GameManager.flappy_died = false

func move_floor(delta):
	if GameManager.flappy_died == false:
		floor_sprite_2d.move_local_x(-160 * delta)
		
	if floor_sprite_2d.position.x <= -192:
		floor_sprite_2d.position.x = -144
