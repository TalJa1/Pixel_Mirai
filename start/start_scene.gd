extends Node2D


func _on_play_btn_pressed() -> void:
  get_tree().change_scene("res://game/game_scene.tscn")


func _on_quit_btn_pressed() -> void:
  get_tree().quit()
