extends RigidBody2D

class_name Marble

enum MarbleType {
	MARBLE_1,
	MARBLE_2,
	MARBLE_3,
	MARBLE_4,
	MARBLE_5,
	MARBLE_6
}

@export var NextMarble: PackedScene;
@export var type: MarbleType;

var hit = false;

func _ready() -> void:
	if (type == MarbleType.MARBLE_6):
		return;
	body_entered.connect(_on_body_entered);
	pass;


func _on_body_entered(body: Node) -> void:
	if (hit || !(body is Marble)):
		return;
		
	if (body.type == type):
		if (body.hit):
			return;

		hit = true;
		body.hit = true;
		
		var marble = NextMarble.instantiate();
		add_sibling(marble);
		marble.global_position = (global_position + body.global_position)/2;
		
		body.queue_free()
		queue_free()
	pass;
