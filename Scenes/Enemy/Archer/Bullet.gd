extends HitBox2D

var fly_speed:float = 100.0
var velocity:Vector2 = Vector2.RIGHT 



func _physics_process(delta):
	position += velocity * fly_speed * delta


func _on_timer_timeout():
	queue_free()
