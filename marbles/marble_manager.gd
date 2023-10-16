extends Node

class_name MarbleManager

@export var marble_1: PackedScene = preload("res://marbles/marble_1.tscn");
@export var marble_2: PackedScene = preload("res://marbles/marble_2.tscn");
@export var marble_3: PackedScene = preload("res://marbles/marble_3.tscn");
@export var marble_4: PackedScene = preload("res://marbles/marble_4.tscn");
@export var marble_5: PackedScene = preload("res://marbles/marble_5.tscn");
@export var marble_6: PackedScene = preload("res://marbles/marble_6.tscn");

# signal marble_drop(position: Vector2)
signal marble_reload(currentMarble: Marble.MarbleType, nextMarble: Marble.MarbleType)

var marbleToScene = {
	Marble.MarbleType.MARBLE_1: marble_1,
	Marble.MarbleType.MARBLE_2: marble_2,
	Marble.MarbleType.MARBLE_3: marble_3,
	Marble.MarbleType.MARBLE_4: marble_4,
	Marble.MarbleType.MARBLE_5: marble_5,
	Marble.MarbleType.MARBLE_6: marble_6,
}

var marbleToPoints = {
	Marble.MarbleType.MARBLE_1: 2,
	Marble.MarbleType.MARBLE_2: 5,
	Marble.MarbleType.MARBLE_3: 10,
	Marble.MarbleType.MARBLE_4: 20,
	Marble.MarbleType.MARBLE_5: 50,
	Marble.MarbleType.MARBLE_6: 75,
}

var marbleToSprite = {
	Marble.MarbleType.MARBLE_1: preload("res://assets/suika_blob1.png"),
	Marble.MarbleType.MARBLE_2: preload("res://assets/suika_blob2.png"),
	Marble.MarbleType.MARBLE_3: preload("res://assets/suika_blob3.png"),
	Marble.MarbleType.MARBLE_4: preload("res://assets/suika_blob4.png"),
	Marble.MarbleType.MARBLE_5: preload("res://assets/suika_blob5.png"),
	Marble.MarbleType.MARBLE_6: preload("res://assets/suika_blob6.png"),
}

var droppableMarbles: Array[Marble.MarbleType] = [
	Marble.MarbleType.MARBLE_1,
	Marble.MarbleType.MARBLE_2,
	Marble.MarbleType.MARBLE_3,
	Marble.MarbleType.MARBLE_4
];

var currentMarble: Marble.MarbleType;
var nextMarble: Marble.MarbleType;
var keys = Marble.MarbleType.keys();

func getAll() -> Array[Marble]:
	var marbles: Array[Marble] = [];
	for node in get_tree().get_nodes_in_group("marbles"):
		if (node is Marble):
			marbles.push_front(node as Marble)
	return marbles;

func reload() -> void:
	currentMarble = nextMarble;
	nextMarble = droppableMarbles[randi_range(0, droppableMarbles.size() - 1)];
	marble_reload.emit(currentMarble, nextMarble);

func drop(spawnPosition: Vector2) -> Marble:
	var marble = marbleToScene[currentMarble].instantiate();
	marble.global_position = spawnPosition
	return marble
