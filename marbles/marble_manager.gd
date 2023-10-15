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


func reload() -> void:
	currentMarble = nextMarble;
	nextMarble = droppableMarbles[randi_range(0, droppableMarbles.size() - 1)];
	marble_reload.emit(currentMarble, nextMarble);

	# currentLabel.text = "Current Marble: " + str(keys[currentMarble]);
	# nextLabel.text = "Next Marble: " + str(keys[nextMarble]);
	# dropSprite.texture = marbleToSprite[currentMarble];

func drop(spawnPosition: Vector2) -> Marble:
	var marble = marbleToScene[currentMarble].instantiate();
	marble.global_position = spawnPosition
	return marble
#
#	add_child(marble);
#	reload();
