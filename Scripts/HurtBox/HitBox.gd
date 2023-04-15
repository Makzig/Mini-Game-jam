extends Area2D
class_name HitBox2D

@export_range(0, 500.0) var damage = 50.0




func _ready() -> void:
	if !self.is_in_group("HitBox"):
		add_to_group("HitBox")
