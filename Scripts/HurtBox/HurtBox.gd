extends Area2D
class_name HurtBox2D


@export_range(0, 1000.0) var max_health:float = 100.0

signal hurted
signal killed

func _ready() -> void:
	area_entered.connect(_on_hurt_entered)



func _on_hurt_entered(area) -> void:
	if !area is HitBox2D:return
	take_damage(area.damage)
	



func take_damage(damage:float) -> void:
	if damage < 0:return
	max_health = max(max_health - damage, 0)
	hurted.emit()
	if max_health <= 0:
		killed.emit()

