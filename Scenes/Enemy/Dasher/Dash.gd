extends State


##Dash
@export_node_path("HurtBox2D") var hurtbox


var _player:CharacterBody2D
var _dash_timer:Timer
var _health_box:HurtBox2D

var _dash_speed:float = 3000.0




func enter_state(_need:Dictionary = {}) -> void:
	_player = owner as CharacterBody2D
	_dash_timer = $DashTimer
	_health_box = get_node(hurtbox)
	_dash_timer.timeout.connect(_on_timeout)
	_health_box.killed.connect(_on_killed)
	_dash_timer.start()


func exit_state() -> void:
	_dash_timer.timeout.disconnect(_on_timeout)
	_health_box.killed.disconnect(_on_killed)


func physics_update(_delta:float) -> void:
	run_to_player()


func run_to_player() -> void:
	var delta_time = get_physics_process_delta_time()
	_player.velocity.x = _dash_speed * delta_time
	_player.move_and_slide()



func _on_timeout() -> void:
	state_machine.change_to("Patrul")

func _on_killed() -> void:
	state_machine.change_to("Dead")
