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
@onready var single_timer: Timer = $SingleTimer
@onready var pack_timer: Timer = $PackTimer

var isRolling = false;
var cases: Array[RigidBody2D] = [];

var singlePrice: int = 1000;
var packPrice: int = 10000;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wallet_label.text = Global.walletToString();
	for node in get_tree().get_nodes_in_group("falling_cases"):
		node.freeze = true;
		if (node is FallingCase):
			node.firstCollision.connect(handleCollisionSound, CONNECT_ONE_SHOT);
		if (node is RigidBody2D):
			cases.push_back(node);

	if (Global.playerData.wallet >= singlePrice): button_buy_1.disabled = false;
	if (Global.playerData.wallet >= packPrice): button_buy_10.disabled = false;

	return;


func resetRollAnimations() -> void:
	case_rect.texture = CASE_CLOSED_TEXTURE;
	results_label.text = "";
	button_buy_1.show();
	button_buy_10.show();


func _on_button_buy_1_pressed() -> void:
	# spend money
	var purchaseSuccessful = Global.spendFromWallet(singlePrice);
	if (!purchaseSuccessful): return;

	var singleCase: FallingCase = cases[0];

	# cases falls
	singleCase.freeze = false;
	await singleCase.firstCollision;

	single_timer.wait_time = 1;
	single_timer.start();
	await single_timer.timeout;


	# open case
	popAllCases();

	# set results text
	results_label.text = "YOU GOT A THING!"

	single_timer.wait_time = 5;
	single_timer.start();
	await single_timer.timeout;

	# head back to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn");

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
	# spend money
	var purchaseSuccessful = Global.spendFromWallet(packPrice);
	if (!purchaseSuccessful): return;

	for case in cases:
		case.freeze = false;

	await big_boi_timer.timeout
	popAllCases()


	# set results text
	results_label.text = "YOU GOT 10 THING!"


	pack_timer.wait_time = 5;
	pack_timer.start();
	await pack_timer.timeout;

	# head back to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn");

	return;

func _on_button_back_pressed() -> void:
	if (isRolling):
		resetRollAnimations();
		isRolling = false;
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn");
	return;

func purchaseCharacter(amountToPurchase: int) -> void:
	var purchaseSuccessful = Global.spendFromWallet(amountToPurchase);

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
	if (hasHitSumthin): return;
	hasHitSumthin = true;
	audio_stream_player_2.play(0);
	# big_boi_timer.timeout.connect(popAllCases, CONNECT_ONE_SHOT);
	big_boi_timer.start(1);
	return;

func popAllCases() -> void:
	print(">> popped");
	for node in get_tree().get_nodes_in_group("falling_cases_textures"):
		node.texture = CASE_OPEN_TEXTURE;

func handleCollisionSound() -> void:
	print(">> play sound")
	audio_stream_player.play(0);
	return;
