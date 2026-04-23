extends Node

@export var scene_path : String


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(scene_path)
