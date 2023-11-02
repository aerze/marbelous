extends Node

class_name MarbleManager

@export var marbleSet: MarbleSet;

@export var droppableMarbles: Array[Marble.Type] = [
	Marble.Type.MARBLE_0,
	Marble.Type.MARBLE_1,
	Marble.Type.MARBLE_2,
	Marble.Type.MARBLE_3,
];

signal marble_dropped();
signal marble_reloaded(currentMarble: Marble.Type, nextMarbleType: Marble.Type);
signal marble_matched(marbleType: Marble.Type);

#var currentMarbleType: Marble.Type = getRandomDroppableMarbleType();
var currentMarbleType: Marble.Type = Marble.Type.MARBLE_0;
var nextMarbleType: Marble.Type = getRandomDroppableMarbleType();
var keys = Marble.Type.keys();

func getRandomDroppableMarbleType() -> Marble.Type:
	return droppableMarbles[randi_range(0, droppableMarbles.size() - 1)];

func getAllActiveMarbles() -> Array[Marble]:
	var marbles: Array[Marble] = [];
	for node in get_tree().get_nodes_in_group("marbles"):
		if (node is Marble):
			marbles.push_front(node as Marble)
	return marbles;

func reload() -> void:
	currentMarbleType = nextMarbleType;
	nextMarbleType = getRandomDroppableMarbleType();
	marble_reloaded.emit(currentMarbleType, nextMarbleType);
	return;

func handleHit(type: Marble.Type, spawnPosition: Vector2):
	var nextType: Marble.Type = marbleSet.getNextType(type);
	var marble: Marble = marbleSet.create(nextType, spawnPosition);
	marble.match_hit.connect(handleHit);
	add_sibling(marble);
	marble_matched.emit(type);
	return;

func drop(spawnPosition: Vector2) -> Marble:
	var marble = marbleSet.create(currentMarbleType, spawnPosition);
	marble.match_hit.connect(handleHit);
	add_child(marble);
	marble_dropped.emit();
	reload();
	return marble

func freezeAll():
	for marble in getAllActiveMarbles():
		marble.freeze = true;

func unfreezeAll():
	for marble in getAllActiveMarbles():
		marble.freeze = false;
