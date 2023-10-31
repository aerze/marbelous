extends Control


var marble_game: PackedScene = preload("res://scenes/game/marble_game.tscn");

func _on_play_button_pressed() -> void:
	print_debug("pressed");
	get_tree().change_scene_to_packed(marble_game);
	pass # Replace with function body.



