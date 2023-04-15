extends State


## Dash


@export_node_path("HitBox2D") var hitbox
@export_node_path("HurtBox2D") var hurtbox


@onready var _health_box:HurtBox2D = get_node(hurtbox)
@onready var _attack_area = get_node(hitbox)
@onready var _dash_timer:Timer = $DashTimer
@onready var _ghost_timer:Timer = $GhostTimer

var ghost:PackedScene = load("res://Scenes/Player/ghost.tscn")


var _dash_direction:Vector2 
var _dash_speed:float = 17000.0


func enter_state(_need:Dictionary = {}) -> void:
	if _need.is_empty():
		state_machine.change_to("Walk")
		return
	
	_dash_direction = _need["dash_direction"]
	
	_dash_timer.connect("timeout", _on_dash_timeout)
	_ghost_timer.timeout.connect(_on_ghost_timeout)
	_dash_timer.start()
	_ghost_timer.start()
	_attack_area.get_node("CollisionShape2D2").set_deferred("disabled", false)
	_health_box.get_node("CollisionShape2D").set_deferred("disabled", true)


func physics_update(_delta:float) -> void:
	owner.velocity = _dash_direction.normalized() * _dash_speed * _delta
	owner.move_and_slide()


func exit_state() -> void:
	_dash_timer.timeout.disconnect(_on_dash_timeout)
	_ghost_timer.timeout.disconnect(_on_ghost_timeout)
	_attack_area.get_node("CollisionShape2D2").set_deferred("disabled", true)
	_health_box.get_node("CollisionShape2D").set_deferred("disabled", false)



func _on_dash_timeout() -> void:
	state_machine.change_to("Walk")

func _on_ghost_timeout() -> void:
	spawn_ghost()

func spawn_ghost() -> void:
	var effect  = ghost.instantiate()
	owner.get_parent().add_child(effect)
	effect.global_position = owner.global_position
