extends Node2D

#TODO:
# - kill plane
# - better UI
# - points

@onready var currentLabel: Label = $UICanvasLayer/Control/CurrentLabel
@onready var nextLabel: Label = $UICanvasLayer/Control/NextLabel
@onready var cursor: CursorSprite2D = $drop_cursor

var Marbles = MarbleManager.new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialize marbles
	Marbles.reload();
	Marbles.marble_reload.connect(handleStateUpdate);
	
	# hide hardware cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

  # lock in cursor position
	cursor.position.x = cursor.cursorStart;
	cursor.position.y = cursor.getHeight();
	return;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("drop")):
		add_child(Marbles.drop(cursor.position));
		Marbles.reload();
	return;

func _process(delta: float) -> void:
	var left = Input.is_action_pressed("move_left");
	var right = Input.is_action_pressed("move_right");
	
	if (left || right):
		cursor.position.y = cursor.getHeight();
	if (left):
		cursor.position.x = maxf((cursor.position.x - (cursor.cursorSpeed * delta)), cursor.cursorStart);
	elif (right):
		cursor.position.x = minf((cursor.position.x + (cursor.cursorSpeed * delta)), cursor.cursorEnd);
	return;

func handleStateUpdate(currentMarble: Marble.MarbleType, nextMarble: Marble.MarbleType) -> void:
	currentLabel.text = "Current Marble: " + str(Marbles.keys[currentMarble]);
	nextLabel.text = "Next Marble: " + str(Marbles.keys[nextMarble]);
	cursor.texture = Marbles.marbleToSprite[currentMarble];
	
