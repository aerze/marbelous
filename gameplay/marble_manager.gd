extends Node

class_name MarbleManager

@export var marbleSet: MarbleSet;

@onready var main: Main = $"..";

# signal marble_drop(position: Vector2)
signal marble_reload(currentMarble: Marble.Type, nextMarbleType: Marble.Type)

# Marble.Type.MARBLE_1: Vector2(0.2, 0.2),
# Marble.Type.MARBLE_2: Vector2(0.3, 0.3),
# Marble.Type.MARBLE_3: Vector2(0.4, 0.4),
# Marble.Type.MARBLE_4: Vector2(0.5, 0.5),
# Marble.Type.MARBLE_5: Vector2(0.8, 0.8),
# Marble.Type.MARBLE_6: Vector2(1.0, 1.0),
# Marble.Type.MARBLE_7: Vector2(1.4, 1.4),
# Marble.Type.MARBLE_8: Vector2(1.8, 1.8),
# Marble.Type.MARBLE_9: Vector2(2.0, 2.0),
# Marble.Type.MARBLE_10: Vector2(2.2, 2.2),\

var droppableMarbles: Array[Marble.Type] = [
	Marble.Type.MARBLE_0,
	Marble.Type.MARBLE_1,
	Marble.Type.MARBLE_2,
	Marble.Type.MARBLE_3,
];

var currentMarbleType: Marble.Type = getRandomMarble();
var nextMarbleType: Marble.Type = getRandomMarble();
var keys = Marble.Type.keys();

func getRandomMarble() -> Marble.Type:
	return droppableMarbles[randi_range(0, droppableMarbles.size() - 1)];

func getAllActiveMarbles() -> Array[Marble]:
	var marbles: Array[Marble] = [];
	for node in get_tree().get_nodes_in_group("marbles"):
		if (node is Marble):
			marbles.push_front(node as Marble)
	return marbles;

func reload() -> void:
	currentMarbleType = nextMarbleType;
	nextMarbleType = getRandomMarble();
	marble_reload.emit(currentMarbleType, nextMarbleType);
	return;

func handleHit(type: Marble.Type, spawnPosition: Vector2):
	var nextType: Marble.Type = marbleSet.getNextType(type);
	var marble: Marble = marbleSet.create(nextType, spawnPosition, self);
	# TODO: defer adding as sibling
	add_sibling(marble);
	main.handleHit(type);
	return;

func drop(spawnPosition: Vector2) -> Marble:
	return marbleSet.create(currentMarbleType, spawnPosition, self);

