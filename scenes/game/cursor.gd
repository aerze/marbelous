extends Sprite2D

class_name CursorSprite2D

@export var cursorSpeed: int = 300;
@export_range(100, 200) var cursorHeight: int = 50;
@export_range(0, 640) var cursorStart: int = 0 + 40;
@export_range(0, 640) var cursorEnd: int = 640 - 40;
@export var cursorFloor: int = 250;

func getHeight() -> float:
	return cursorFloor - cursorHeight;
