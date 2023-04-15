extends State


##Onready and enter state
@export_node_path("AnimatedSprite2D") var anim_sprite 
@export_node_path("HurtBox2D") var hurtbox
@export_node_path("Area2D") var detect_area 
@export_node_path("Marker2D") var pivot


@onready var _pivot:Marker2D = get_node(pivot)
@onready var _detected_area:Area2D = get_node(detect_area)
@onready var _health_box:HurtBox2D = get_node(hurtbox)
@onready var _animade_sprite:AnimatedSprite2D = get_node(anim_sprite)
var _enemy_body:CharacterBody2D

var _move_speed:float = 1500.0
var _direction:int = 1


func enter_state(_need:Dictionary = {}) -> void:
	_enemy_body = owner as CharacterBody2D
	_detected_area.body_entered.connect(_on_detect)
	_health_box.killed.connect(_on_killed)


func exit_state() -> void:
	_detected_area.body_entered.disconnect(_on_detect)
	_health_box.killed.disconnect(_on_killed)


func physics_update(_delta:float) -> void:
	movement()

func movement() -> void:
	var delta_time = get_physics_process_delta_time()
	_enemy_body.velocity.x = _direction * _move_speed * delta_time
	_enemy_body.move_and_slide()
	if _enemy_body.is_on_wall():flip_to_wall()


func flip_to_wall() -> void:
	if anim_sprite:_animade_sprite.flip_h = !_animade_sprite.flip_h
	_direction *= -1
	_pivot.rotation_degrees += 180 * _direction


func _on_detect(body) -> void:
	if !body.is_in_group("Player"):return
	state_machine.change_to("Attack", {target = body})


func _on_killed() -> void:
	state_machine.change_to("Dead")
