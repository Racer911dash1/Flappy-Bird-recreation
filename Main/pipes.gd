extends Node2D
class_name Pipes

var pipe_speed : int = 160

func _physics_process(delta: float) -> void:
	if GameManager.flappy_died == false:
		move_local_x(-pipe_speed * delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
