extends RigidBody2D

class_name FallingCase

signal firstCollision;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(handleFirstCollision, CONNECT_ONE_SHOT);
	return;

func handleFirstCollision(body: Node) -> void:
	firstCollision.emit();
	return;
