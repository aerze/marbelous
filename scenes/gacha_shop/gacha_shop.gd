extends Node2D

@export var CASE_CLOSED_TEXTURE: Texture2D;
@export var CASE_OPEN_TEXTURE: Texture2D;
@export var characterRollChance: float = 0.33;

@onready var case_rect: TextureRect = $CanvasLayer/MainControl/VBoxContainer/CaseRect
@onready var wallet_label: Label = $CanvasLayer/MainControl/WalletLabel
@onready var results_label: Label = $CanvasLayer/MainControl/ResultsLabel
@onready var button_buy_1: Button = $CanvasLayer/MainControl/VBoxContainer/ButtonBuy1
@onready var button_buy_10: Button = $CanvasLayer/MainControl/VBoxContainer/ButtonBuy10

var isRolling = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wallet_label.text = Global.walletToString();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func resetRollAnimations() -> void:
	case_rect.texture = CASE_CLOSED_TEXTURE;
	results_label.text = "";
	button_buy_1.show();
	button_buy_10.show();


func _on_button_buy_1_pressed() -> void:
	resetRollAnimations();

	isRolling = true;
	button_buy_1.hide();
	button_buy_10.hide();

	var purchaseSuccessful = Global.walletSpend(1);
	if (purchaseSuccessful):
		wallet_label.text = Global.walletToString();

		var rollSuccessful = randf() <= characterRollChance;
		# create items to be launched
		#
		if (rollSuccessful):
			results_label.text = "CHARACTER GET!";
			case_rect.texture = CASE_OPEN_TEXTURE;
			return;


	results_label.text = "MISS!";

	return;

func _on_button_buy_10_pressed() -> void:
	purchaseCharacter(10);
	return;

func _on_button_back_pressed() -> void:
	if (isRolling):
		resetRollAnimations();
		isRolling = false;
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn");
	return;




func purchaseCharacter(amountToPurchase: int) -> void:
	var purchaseSuccessful = Global.walletSpend(amountToPurchase);

	if (purchaseSuccessful):
		wallet_label.text = Global.walletToString();

		# roll for character or filler
		var characterGet = randf() <= 0.33;
		if (characterGet):
			results_label.text = "CHARACTER GET!";
			case_rect.texture = CASE_OPEN_TEXTURE;
			# pick a character
			return;

	results_label.text = "YOU GET NOTHING!";
	case_rect.texture = CASE_CLOSED_TEXTURE;

	# display chacter or filler
	# show new buttons for re-roll or back?
	return;
