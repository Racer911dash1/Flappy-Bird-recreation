extends Sprite2D

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/main.tscn")
