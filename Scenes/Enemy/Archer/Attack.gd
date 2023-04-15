extends State

@export_file var bullet
@export_node_path("HurtBox2D") var hurtbox
@export_node_path("Area2D") var detect_area
@export_node_path("Marker2D") var pivot



@onready var _health_box:HurtBox2D = get_node(hurtbox)
@onready var _detected_area:Area2D = get_node(detect_area)
@onready var _shoot_timer:Timer = $Timer
@onready var _shoot_pivot:Marker2D = get_node(pivot)

var _target:CharacterBody2D


func enter_state(_need:Dictionary = {}) -> void:
	if !_need.has("target"):
		state_machine.change_to("Walk")
		return
	_target = _need["target"]
	_health_box.killed.connect(_on_killed)
	_detected_area.body_exited.connect(_on_target_exited)
	
	
	_shoot_timer.timeout.connect(_on_shoot_finished)
	_shoot_timer.start()

func exit_state() -> void:
	_health_box.killed.disconnect(_on_killed)
	_detected_area.body_exited.disconnect(_on_target_exited)
	_shoot_timer.timeout.disconnect(_on_shoot_finished)


func shoot() -> void:
	var bul = load(bullet).instantiate()
	var parent_scene = owner.get_parent()
	var shoot_pos = _shoot_pivot.get_node("ShootPos")
	parent_scene.add_child(bul)
	bul.global_position = shoot_pos.global_position
	bul.velocity = bul.velocity.rotated(owner.position.direction_to(_target.global_position).angle()) #+ PI/2)
	bul.rotation = bul.velocity.angle()
	_shoot_timer.start()


func _on_shoot_finished() -> void:
	shoot()


func _on_target_exited(body) -> void:
	if !body.is_in_group("Player"):return
	state_machine.change_to("Walk")

func _on_killed() -> void:
	state_machine.change_to("Dead")

