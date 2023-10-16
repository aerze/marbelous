extends Node2D

class_name Main

#TODO:
# - better UI
# - points

@onready var nextLabel: Label = $UICanvasLayer/Control/NextLabel
@onready var nextTextureRect: TextureRect = $UICanvasLayer/Control/NextTextureRect
@onready var pointsLabel: Label = $UICanvasLayer/Control/PointsLabel
@onready var gameStateLabel: Label = $UICanvasLayer/Control/GameStateLabel
@onready var cursor: CursorSprite2D = $drop_cursor
@onready var dropCheckTimer: Timer = $DropCheckTimer
@onready var noZone: Area2D = $DoNotPassGoZone

enum GameState {
	READY,
	DROPPING,
	GAME_OVER,
}

var Marbles = MarbleManager.new();
var gameState: GameState = GameState.READY:
	set(value):
		gameState = value;
		gameStateLabel.text = str("GameState: ",  GameState.keys()[value]);
		
var points: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialize marbles
	add_child(Marbles);
	Marbles.reload();
	Marbles.marble_reload.connect(handleStateUpdate);
	dropCheckTimer.timeout.connect(handleFinishedDropping);
	
	# hide hardware cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

  # lock in cursor position
	cursor.position.x = cursor.cursorStart;
	cursor.position.y = cursor.getHeight();
	return;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("drop")):
		handleDrop();
	return;

func _process(delta: float) -> void:
	handleInput(delta);
	
	if (gameState == GameState.READY):
		if (noZone.has_overlapping_bodies()):
			handleGameOver();
	return;
	
func handleInput(delta: float) -> void:
	if (gameState == GameState.GAME_OVER): return;
	var left = Input.is_action_pressed("move_left");
	var right = Input.is_action_pressed("move_right");
	
	if (left || right):
		cursor.position.y = cursor.getHeight();
	if (left):
		cursor.position.x = maxf((cursor.position.x - (cursor.cursorSpeed * delta)), cursor.cursorStart);
	elif (right):
		cursor.position.x = minf((cursor.position.x + (cursor.cursorSpeed * delta)), cursor.cursorEnd);
	
func handleGameOver() -> void:
	dropCheckTimer.stop();
	gameState = GameState.GAME_OVER;
	for marble in Marbles.getAll():
		marble.freeze = true;

func handleDrop() -> void:
	if (gameState == GameState.GAME_OVER): return;
	gameState = GameState.DROPPING;
	dropCheckTimer.start();
	add_child(Marbles.drop(cursor.position));
	Marbles.reload();

func handleFinishedDropping() -> void:
	gameState = GameState.READY;
	return;

func handleStateUpdate(currentMarble: Marble.MarbleType, nextMarble: Marble.MarbleType) -> void:
	if (gameState == GameState.GAME_OVER): return;
#	nextLabel.text = "Next Marble: " + str(Marbles.keys[nextMarble]);
	nextTextureRect.texture = Marbles.marbleToSprite[nextMarble];
	cursor.texture = Marbles.marbleToSprite[currentMarble];

func handleHit(type: Marble.MarbleType) -> void:
	points += Marbles.marbleToPoints[type];
	pointsLabel.text = str("Points: ", points);
	pass;

func _on_reset_button_pressed() -> void:
	if (gameState != GameState.GAME_OVER): return;
	gameState = GameState.READY;
	for marble in Marbles.getAll():
		marble.freeze = true;
		marble.queue_free();
