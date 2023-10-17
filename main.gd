extends Node2D

class_name Main

@onready var nextLabel: Label = $UICanvasLayer/Control/NextLabel
@onready var nextTextureRect: TextureRect = $UICanvasLayer/Control/NextTextureRect
@onready var pointsLabel: Label = $UICanvasLayer/Control/PointsLabel
@onready var gameStateLabel: Label = $UICanvasLayer/Control/GameStateLabel
@onready var cursor: CursorSprite2D = $drop_cursor
@onready var dropCheckTimer: Timer = $DropCheckTimer
@onready var noZone: Area2D = $DoNotPassGoZone
@onready var mobile_control: Control = $UICanvasLayer/Control/MobileControl
@onready var button_left: TouchScreenButton = $UICanvasLayer/Control/MobileControl/ButtonLeft
@onready var button_right: TouchScreenButton = $UICanvasLayer/Control/MobileControl/ButtonRight
@onready var button_drop: TouchScreenButton = $UICanvasLayer/Control/MobileControl/ButtonDrop

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
	Marbles.marble_reload.connect(handleStateUpdate);
	dropCheckTimer.timeout.connect(handleFinishedDropping);
	Marbles.reload();
	
	# hide hardware cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

  # lock in cursor position
	cursor.position.x = cursor.cursorStart;
	cursor.position.y = cursor.getHeight();
	
	if (OS.get_name() == "Android"):
		mobile_control.show();
	return;

func _input(event: InputEvent) -> void:
	if (OS.get_name() == "Android"): return;
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
	var left = Input.is_action_pressed("move_left") || button_left.is_pressed();
	var right = Input.is_action_pressed("move_right") || button_right.is_pressed();
	
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
	nextTextureRect.texture = Marbles.marbleToSprite[nextMarble];
	cursor.texture = Marbles.marbleToSprite[currentMarble];
	cursor.scale = Marbles.marbleToScale[currentMarble];

func handleHit(type: Marble.MarbleType) -> void:
	points += Marbles.marbleToPoints[type];
	pointsLabel.text = str("Points: ", points);
	pass;

func _on_reset_button_pressed() -> void:
	if (gameState != GameState.GAME_OVER): return;
	
	for marble in Marbles.getAll():
		marble.freeze = true;
		marble.queue_free();
	await get_tree().physics_frame;
	
	gameState = GameState.READY;

	points = 0;
	pointsLabel.text = "Points: 0";
	
	Marbles.nextMarble = Marbles.getRandomMarble();
	Marbles.currentMarble = Marbles.getRandomMarble();
	
	nextTextureRect.texture = Marbles.marbleToSprite[Marbles.nextMarble];
	cursor.texture = Marbles.marbleToSprite[Marbles.currentMarble];
	cursor.scale = Marbles.marbleToScale[Marbles.currentMarble];
	
	cursor.position.x = cursor.cursorStart;
	cursor.position.y = cursor.getHeight();

func _on_button_drop_pressed() -> void:
	handleDrop()
	pass # Replace with function body.
