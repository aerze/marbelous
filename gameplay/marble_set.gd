extends Resource

class_name MarbleSet

@export var marble_0: PackedScene;
@export var marble_0_texture: CompressedTexture2D;
@export var marble_0_points: float = 2;
@export var marble_0_scale: Vector2 = Vector2(1, 1);

@export var marble_1: PackedScene;
@export var marble_1_texture: CompressedTexture2D;
@export var marble_1_points: float = 5;
@export var marble_1_scale: Vector2 = Vector2(1, 1);

@export var marble_2: PackedScene;
@export var marble_2_texture: CompressedTexture2D;
@export var marble_2_points: float = 10;
@export var marble_2_scale: Vector2 = Vector2(1, 1);

@export var marble_3: PackedScene;
@export var marble_3_texture: CompressedTexture2D;
@export var marble_3_points: float = 20;
@export var marble_3_scale: Vector2 = Vector2(1, 1);

@export var marble_4: PackedScene;
@export var marble_4_texture: CompressedTexture2D;
@export var marble_4_points: float = 50;
@export var marble_4_scale: Vector2 = Vector2(1, 1);

@export var marble_5: PackedScene;
@export var marble_5_texture: CompressedTexture2D;
@export var marble_5_points: float = 75;
@export var marble_5_scale: Vector2 = Vector2(1, 1);

@export var marble_6: PackedScene;
@export var marble_6_texture: CompressedTexture2D;
@export var marble_6_points: float = 100;
@export var marble_6_scale: Vector2 = Vector2(1, 1);

@export var marble_7: PackedScene;
@export var marble_7_texture: CompressedTexture2D;
@export var marble_7_points: float = 200;
@export var marble_7_scale: Vector2 = Vector2(1, 1);

@export var marble_8: PackedScene;
@export var marble_8_texture: CompressedTexture2D;
@export var marble_8_points: float = 300;
@export var marble_8_scale: Vector2 = Vector2(1, 1);

@export var marble_9: PackedScene;
@export var marble_9_texture: CompressedTexture2D;
@export var marble_9_points: float = 500;
@export var marble_9_scale: Vector2 = Vector2(1, 1);

@export var marble_10: PackedScene;
@export var marble_10_texture: CompressedTexture2D;
@export var marble_10_points: float = 1000;
@export var marble_10_scale: Vector2 = Vector2(1, 1);

@export var last_marble_type: Marble.Type = Marble.Type.MARBLE_END;

func getScene(type: Marble.Type) -> PackedScene:
	match type:
		Marble.Type.MARBLE_0:
			return marble_0;
		Marble.Type.MARBLE_1:
			return marble_1;
		Marble.Type.MARBLE_2:
			return marble_2;
		Marble.Type.MARBLE_3:
			return marble_3;
		Marble.Type.MARBLE_4:
			return marble_4;
		Marble.Type.MARBLE_5:
			return marble_5;
		Marble.Type.MARBLE_6:
			return marble_6;
		Marble.Type.MARBLE_7:
			return marble_7;
		Marble.Type.MARBLE_8:
			return marble_8;
		Marble.Type.MARBLE_9:
			return marble_9;
		Marble.Type.MARBLE_10:
			return marble_10;
		_:
			return marble_0;
	
func getTexture(type: Marble.Type) -> CompressedTexture2D:
	match type:
		Marble.Type.MARBLE_0:
			return marble_0_texture;
		Marble.Type.MARBLE_1:
			return marble_1_texture;
		Marble.Type.MARBLE_2:
			return marble_2_texture;
		Marble.Type.MARBLE_3:
			return marble_3_texture;
		Marble.Type.MARBLE_4:
			return marble_4_texture;
		Marble.Type.MARBLE_5:
			return marble_5_texture;
		Marble.Type.MARBLE_6:
			return marble_6_texture;
		Marble.Type.MARBLE_7:
			return marble_7_texture;
		Marble.Type.MARBLE_8:
			return marble_8_texture;
		Marble.Type.MARBLE_9:
			return marble_9_texture;
		Marble.Type.MARBLE_10:
			return marble_10_texture;
		_:
			return marble_0_texture;

func getPoints(type: Marble.Type) -> float:
	match type:
		Marble.Type.MARBLE_0:
			return marble_0_points;
		Marble.Type.MARBLE_1:
			return marble_1_points;
		Marble.Type.MARBLE_2:
			return marble_2_points;
		Marble.Type.MARBLE_3:
			return marble_3_points;
		Marble.Type.MARBLE_4:
			return marble_4_points;
		Marble.Type.MARBLE_5:
			return marble_5_points;
		Marble.Type.MARBLE_6:
			return marble_6_points;
		Marble.Type.MARBLE_7:
			return marble_7_points;
		Marble.Type.MARBLE_8:
			return marble_8_points;
		Marble.Type.MARBLE_9:
			return marble_9_points;
		Marble.Type.MARBLE_10:
			return marble_10_points;
		_:
			return marble_0_points;

func getScale(type: Marble.Type) -> Vector2:
	match type:
		Marble.Type.MARBLE_0:
			return marble_0_scale;
		Marble.Type.MARBLE_1:
			return marble_1_scale;
		Marble.Type.MARBLE_2:
			return marble_2_scale;
		Marble.Type.MARBLE_3:
			return marble_3_scale;
		Marble.Type.MARBLE_4:
			return marble_4_scale;
		Marble.Type.MARBLE_5:
			return marble_5_scale;
		Marble.Type.MARBLE_6:
			return marble_6_scale;
		Marble.Type.MARBLE_7:
			return marble_7_scale;
		Marble.Type.MARBLE_8:
			return marble_8_scale;
		Marble.Type.MARBLE_9:
			return marble_9_scale;
		Marble.Type.MARBLE_10:
			return marble_10_scale;
		_:
			return marble_0_scale;

func getNextType(type: Marble.Type) -> Marble.Type:
	var nextTypeString = Marble.Type.keys()[type + 1];
	var nextType = Marble.Type[nextTypeString];
	if (nextType == last_marble_type):
		return last_marble_type;
	else:
		return nextType;

func create(type: Marble.Type, position: Vector2, manager: MarbleManager) -> Marble:
	var marbleScene = getScene(type) as PackedScene;
	var marble = marbleScene.instantiate() as Marble;
	var scale = getScale(type);
	marble.type = type;
	marble.global_position = position;
	marble.manager = manager
	marble.setScale(scale);
	return marble;
	
