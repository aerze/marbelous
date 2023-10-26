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

var hit: bool = false;
var type: Marble.Type;
var manager: MarbleManager;

func _ready() -> void:
	add_to_group("marbles");
	body_entered.connect(_on_body_entered);
	return;


func _on_body_entered(body: Node) -> void:
	if (hit || !(body is Marble)):
		return;
		
	if (body.type == type):
		if (body.hit):
			return;

		hit = true;
		body.hit = true;
		
		var spawnPosition = (global_position + body.global_position)/2;
		manager.handleHit(type, spawnPosition);
		
		body.queue_free()
		queue_free()
	return;

func setScale(scale: Vector2) -> void:
	for node in get_children():
		node.scale = scale;
