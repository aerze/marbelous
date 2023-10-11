extends Node2D

var marble_1: PackedScene = preload("res://marbles/marble_1.tscn");
var marble_2: PackedScene = preload("res://marbles/marble_2.tscn");
var marble_3: PackedScene = preload("res://marbles/marble_3.tscn");
var marble_4: PackedScene = preload("res://marbles/marble_4.tscn");
var marble_5: PackedScene = preload("res://marbles/marble_5.tscn");
var marble_6: PackedScene = preload("res://marbles/marble_6.tscn");

@onready var currentLabel: Label = $CanvasLayer/Control/CurrentLabel
@onready var nextLabel: Label = $CanvasLayer/Control/NextLabel
@onready var dropSprite: Sprite2D = $drop_sprite

var marbleToSprite = {
	Marble.MarbleType.MARBLE_1: preload("res://assets/suika_blob1.png"),
	Marble.MarbleType.MARBLE_2: preload("res://assets/suika_blob2.png"),
	Marble.MarbleType.MARBLE_3: preload("res://assets/suika_blob3.png"),
	Marble.MarbleType.MARBLE_4: preload("res://assets/suika_blob4.png"),
	Marble.MarbleType.MARBLE_5: preload("res://assets/suika_blob5.png"),
	Marble.MarbleType.MARBLE_6: preload("res://assets/suika_blob6.png"),
}

#TODO:
# Add bounciness

var droppableMarbles: Array[Marble.MarbleType] = [
	Marble.MarbleType.MARBLE_1,
	Marble.MarbleType.MARBLE_2,
	Marble.MarbleType.MARBLE_3,
	Marble.MarbleType.MARBLE_4
];

var marbleToScene = {
	Marble.MarbleType.MARBLE_1: marble_1,
	Marble.MarbleType.MARBLE_2: marble_2,
	Marble.MarbleType.MARBLE_3: marble_3,
	Marble.MarbleType.MARBLE_4: marble_4,
	Marble.MarbleType.MARBLE_5: marble_5,
	Marble.MarbleType.MARBLE_6: marble_6,
}

var currentMarble: Marble.MarbleType;
var nextMarble: Marble.MarbleType;
var keys = Marble.MarbleType.keys();

func reload() -> void:
	currentMarble = nextMarble;
	currentLabel.text = "Current Marble: " + str(keys[currentMarble]);
	nextMarble = droppableMarbles[randi_range(0, droppableMarbles.size() - 1)];
	nextLabel.text = "Next Marble: " + str(keys[nextMarble]);
	dropSprite.texture = marbleToSprite[currentMarble];
	

func drop(spawnPosition: Vector2) -> void:
	var marble = marbleToScene[currentMarble].instantiate();
	add_child(marble);
	marble.global_position = spawnPosition
	reload();
	pass;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload();
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("drop")):
		if (event is InputEventMouseButton):
			drop(event.position)
			
func _process(delta: float) -> void:
	dropSprite.global_position = get_global_mouse_position();
