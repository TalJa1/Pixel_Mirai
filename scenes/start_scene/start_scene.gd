extends Node2D


func _on_play_btn_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/play_1st_scene/play_1st_scene.tscn")


func _on_quit_btn_pressed() -> void:
  get_tree().quit()
