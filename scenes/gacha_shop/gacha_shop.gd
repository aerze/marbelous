extends Node2D

@export var CASE_CLOSED_TEXTURE: Texture2D;
@export var CASE_OPEN_TEXTURE: Texture2D;
@export var characterRollChance: float = 0.33;

@onready var case_rect: TextureRect = $CanvasLayer/MainControl/VBoxContainer/CaseRect
@onready var wallet_label: Label = $CanvasLayer/MainControl/WalletLabel
@onready var results_label: Label = $CanvasLayer/MainControl/ResultsLabel
@onready var button_buy_1: Button = $CanvasLayer/MainControl/VBoxContainer/ButtonBuy1
@onready var button_buy_10: Button = $CanvasLayer/MainControl/VBoxContainer/ButtonBuy10
@onready var big_boi_timer: Timer = $BigBoiTimer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

var isRolling = false;
var cases: Array[RigidBody2D] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wallet_label.text = Global.walletToString();
	for node in get_tree().get_nodes_in_group("falling_cases"):
		node.freeze = true;
		if (node is FallingCase):
			node.firstCollision.connect(handleCollisionSound, CONNECT_ONE_SHOT);
		if (node is RigidBody2D):
			cases.push_back(node);
	return;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func resetRollAnimations() -> void:
	case_rect.texture = CASE_CLOSED_TEXTURE;
	results_label.text = "";
	button_buy_1.show();
	button_buy_10.show();


func _on_button_buy_1_pressed() -> void:
	cases[0].freeze = false;

	# for node in get_tree().get_nodes_in_group("falling_cases_textures"):
	# 	node.texture = CASE_OPEN_TEXTURE;
	# resetRollAnimations();

	# isRolling = true;
	# button_buy_1.hide();
	# button_buy_10.hide();

	# var purchaseSuccessful = Global.walletSpend(1);
	# if (purchaseSuccessful):
	# 	wallet_label.text = Global.walletToString();

	# 	var rollSuccessful = randf() <= characterRollChance;
	# 	# create items to be launched
	# 	#
	# 	if (rollSuccessful):
	# 		results_label.text = "CHARACTER GET!";
	# 		case_rect.texture = CASE_OPEN_TEXTURE;
	# 		return;


	# results_label.text = "MISS!";

	return;

func _on_button_buy_10_pressed() -> void:
	for case in cases:
		case.freeze = false;
	# purchaseCharacter(10);
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

var hasHitSumthin = false;

func _on_rigid_body_2d_11_body_entered(body: Node) -> void:
	print(">> collided?");
	if (hasHitSumthin): return;
	hasHitSumthin = true;
	audio_stream_player_2.play(0);
	big_boi_timer.timeout.connect(popAllCases, CONNECT_ONE_SHOT);
	big_boi_timer.start(1);
	pass # Replace with function body.

func popAllCases() -> void:
	print(">> popped");
	for node in get_tree().get_nodes_in_group("falling_cases_textures"):
		node.texture = CASE_OPEN_TEXTURE;

func handleCollisionSound() -> void:
	print(">> play sound")
	audio_stream_player.play(0);
	return;
