extends RigidBody2D

class_name Marble

enum Type {
	MARBLE_0,
	MARBLE_1,
	MARBLE_2,
	MARBLE_3,
	MARBLE_4,
	MARBLE_5,
	MARBLE_6,
	MARBLE_7,
	MARBLE_8,
	MARBLE_9,
	MARBLE_10,
	MARBLE_END
}

@export var type: Marble.Type;
@onready var timer: Timer = $MarbleCollisionTimer

signal match_hit(type: Marble.Type, spawnPosition: Vector2);

var hit: bool = false;

func _ready() -> void:
	add_to_group("marbles");
	body_entered.connect(handleBodyEntered);
	timer.timeout.connect(handleTimeout);
	return;


func handleBodyEntered(body: Node) -> void:
	if (hit || !(body is Marble)):
		return;

	if (body.type == type):
		if (body.hit):
			return;

		hit = true;
		body.hit = true;

		var spawnPosition = (global_position + body.global_position)/2;
		match_hit.emit(type, spawnPosition);

		body.queue_free()
		queue_free()
	return;

func handleTimeout() -> void:
	set_collision_layer_value(4, true);

func setScale(newScale: Vector2) -> void:
	for node in get_children():
		if (node is Timer): continue;
		node.scale = newScale;
