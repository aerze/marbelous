extends Control

var marble_game: PackedScene = preload("res://scenes/game/marble_game.tscn");
var gacha_shop: PackedScene = preload("res://scenes/gacha_shop/gacha_shop.tscn");

func _on_play_button_pressed() -> void:
	print_debug("pressed");
	get_tree().change_scene_to_packed(marble_game);
	return;

func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_packed(gacha_shop);
	return;


func _on_settings_button_pressed() -> void:
	Global.playerData.wallet = 100;
	Global.playerData.roll_count = 5;
	Global.saveGame();
	return;

