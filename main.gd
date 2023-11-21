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

@onready var marbles: MarbleManager = $MarbleManager

enum GameState {
	PLAYING,
	GAME_OVER,
}

var gameState: GameState = GameState.PLAYING:
	set(newGameState):
		if (gameState != newGameState):
#			var oldGameState: GameState = gameState;
			gameState = newGameState;
			gamestate_changed.emit(newGameState);
		else: return;

var points: int = 0;

var isAndroid = OS.get_name() == "Android";

signal gamestate_changed(newGameState: GameState);

func handleGameStateChanged(newGameState: GameState):
	gameStateLabel.text = str("GameState: ",  GameState.keys()[newGameState]);
	match (newGameState):
		GameState.PLAYING:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			return;
		GameState.GAME_OVER:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			marbles.freezeAll();
			return;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialize handlers
	gamestate_changed.connect(handleGameStateChanged);
	handleGameStateChanged(gameState);
	marbles.marble_reloaded.connect(updateUI);

	marbles.reload();

	if (isAndroid):
		mobile_control.show();
	return;

func _input(event: InputEvent) -> void:
	if (!isAndroid && event.is_action_pressed("drop")):
		if (gameState == GameState.GAME_OVER): return;
		handleDrop();
	return;

func _process(delta: float) -> void:
	if (gameState == GameState.GAME_OVER): return;
	handleCursorMovement(delta);

	if (noZone.has_overlapping_bodies()):
		gameState = GameState.GAME_OVER;
	return;

func handleCursorMovement(delta: float) -> void:
	var left = Input.is_action_pressed("move_left") || button_left.is_pressed();
	var right = Input.is_action_pressed("move_right") || button_right.is_pressed();

	# if (left || right):
	# 	cursor.position.y = cursor.getHeight();
	if (left):
		cursor.position.x = maxf((cursor.position.x - (cursor.cursorSpeed * delta)), cursor.cursorStart);
	elif (right):
		cursor.position.x = minf((cursor.position.x + (cursor.cursorSpeed * delta)), cursor.cursorEnd);
	return;

func handleDrop() -> void:
	marbles.drop(cursor.position);

func updateUI(currentMarbleType: Marble.Type, nextMarbleType: Marble.Type) -> void:
	nextTextureRect.texture = marbles.marbleSet.getTexture(nextMarbleType);
	cursor.texture = marbles.marbleSet.getTexture(currentMarbleType);
	cursor.scale = marbles.marbleSet.getScale(currentMarbleType);

func handleHit(type: Marble.Type) -> void:
	points += marbles.marbleSet.getPoints(type);
	pointsLabel.text = str("Points: ", points);
	pass;

func _on_reset_button_pressed() -> void:
	if (gameState != GameState.GAME_OVER): return;

	for marble in marbles.getAllActiveMarbles():
		marble.freeze = true;
		marble.queue_free();
	await get_tree().physics_frame;

	gameState = GameState.PLAYING;

	points = 0;
	pointsLabel.text = "Points: 0";

	marbles.nextMarbleType = marbles.getRandomDroppableMarbleType();
	marbles.currentMarbleType = marbles.getRandomDroppableMarbleType();

	nextTextureRect.texture = marbles.marbleSet.getTexture(marbles.nextMarbleType);
	cursor.texture = marbles.marbleSet.getTexture(marbles.currentMarbleType);
	cursor.scale = marbles.marbleSet.getScale(marbles.currentMarbleType);

	cursor.position.x = cursor.cursorStart;
	cursor.position.y = cursor.getHeight();

func _on_button_drop_pressed() -> void:
	handleDrop()
	pass # Replace with function body.
