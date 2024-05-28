extends CharacterBody2D
class_name Flappy

signal pipe_passed
signal hit

@onready var flappy_sprite_2d: Sprite2D = $FlappySprite2D
@onready var flappy_animation_player: AnimationPlayer = $FlappyAnimationPlayer
@onready var jump_audio_stream_player: AudioStreamPlayer = $JumpAudioStreamPlayer
@onready var dead_audio_stream_player: AudioStreamPlayer = $DeadAudioStreamPlayer
@onready var hurtbox_area_2d: Area2D = $HurtboxArea2D
@onready var hit_audio_stream_player: AudioStreamPlayer = $HitAudioStreamPlayer
@onready var point_audio_stream_player: AudioStreamPlayer = $PointAudioStreamPlayer
@onready var point_collect_2d: Area2D = $PointCollect2D

@export var jump : float = 260

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead: bool = false
var apply_gravity_bool : bool = false

func _physics_process(delta: float) -> void:
	global_position.x = 72
	apply_gravity(delta)
	
	if dead == false:
		jumping()
	move_and_slide()

func _on_hurtbox_area_2d_body_entered(body: Node2D) -> void:
	GameManager.flappy_died = true
	hit.emit()
	hit_audio_stream_player.play()
	dead_audio_stream_player.play()
	hurtbox_area_2d.set_collision_mask_value(2, false)
	point_collect_2d.set_collision_mask_value(3, false)
	flappy_animation_player.play("Dead")
	dead = true
	
func jumping():
	if Input.is_action_just_pressed("jump"):
		apply_gravity_bool = true
		jump_audio_stream_player.play()
		velocity.y = -jump

func apply_gravity(delta):
	if apply_gravity_bool == true:
		velocity.y += gravity * delta * 1.5
		rotation = clamp(velocity.y * delta / 6 + deg_to_rad(-15), deg_to_rad(-20), deg_to_rad(90))

func _on_point_collect_2d_area_entered(area: Area2D) -> void:
	point_audio_stream_player.play()
	pipe_passed.emit()
