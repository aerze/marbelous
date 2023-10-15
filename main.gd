extends Node2D

@onready var currentLabel: Label = $UICanvasLayer/Control/CurrentLabel
@onready var nextLabel: Label = $UICanvasLayer/Control/NextLabel
@onready var dropSprite: Sprite2D = $drop_sprite

var Marbles = MarbleManager.new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Marbles.reload();
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("drop")):
		if (event is InputEventMouseButton):
			add_child(Marbles.drop(event.position));
			Marbles.reload();

func _process(delta: float) -> void:
	dropSprite.global_position = get_global_mouse_position();
