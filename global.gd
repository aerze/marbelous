extends Node2D

@export var playerDataPath = "user://playerdata.tres";
@export var playerData: PlayerData;

var unownedCharacters = [0,1,2,3,4,5,6,7,8,9];


func _ready():
	loadGame();
	return;

func loadGame() -> void:
	print(">> Global:loadGame");
	if ResourceLoader.exists(playerDataPath):
		playerData = load(playerDataPath);
		print(playerData.toString());
	else:
		saveGame();
	return;

func saveGame() -> void:
	print(">> Global:saveGame");
	if (!playerData):
		playerData = PlayerData.new();
	print(playerData.toString());
	ResourceSaver.save(playerData, playerDataPath);
	return;

func walletToString() -> String:
	return str("$", playerData.wallet);

func spendFromWallet(amount: int) -> bool:
	if (amount > playerData.wallet):
		return false;
	else:
		playerData.wallet -= amount;
		saveGame();
		return true;
