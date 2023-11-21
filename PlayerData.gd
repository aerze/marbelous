
extends Resource

class_name PlayerData

@export var wallet: int = 0;
@export var roll_count: int = 0;
@export var owned_characters: Array[int] = [];

func toString() -> String:
	return str("$", wallet, " Rolls: ", roll_count, " Collected: ", owned_characters);
