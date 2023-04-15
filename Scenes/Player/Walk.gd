extends State


## Walk


@export_node_path("AnimatedSprite2D") var anim_sprite
@export_node_path("HurtBox2D") var hurtbox
@onready var _sprite:AnimatedSprite2D = get_node(anim_sprite)
@onready var _hurt:HurtBox2D = get_node(hurtbox)


var player:CharacterBody2D
var _anim_player:AnimationPlayer 

var _acceleration:float = 500.0
var _max_speed:float = 2500.0
var _jump_force:float = 970.0
var _gravity:float = 1000.0





func enter_state(_need:Dictionary = {}) -> void:
	player = owner as CharacterBody2D
	_anim_player = player.get_node("AnimationPlayer")
	_hurt.killed.connect(_on_killed)
	_hurt.get_node("CollisionShape2D").set_deferred("disabled", false)


func exit_state() -> void:
	_hurt.get_node("CollisionShape2D").set_deferred("disabled", true)
	_hurt.killed.disconnect(_on_killed)


func physics_update(_delta:float) -> void:
	movement()
	jumping()
	player.move_and_slide()



func handless_input(_event:InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.change_to("Dash", {dash_direction = get_dash_direction()})




func get_dash_direction() -> Vector2:
	return Input.get_last_mouse_velocity()


func movement() -> void:
	var delta_time:float = get_physics_process_delta_time()
	var direction_x = Input.get_axis("move_left", "move_right")
	
	if direction_x:
		player.velocity.x += _acceleration * delta_time * direction_x
		player.velocity.x = clampf(player.velocity.x , -(_max_speed * delta_time) ,_max_speed * delta_time)
		flip(direction_x)
		_anim_player.play("Walk")
	else:
		_anim_player.play("Idle")
		player.velocity.x = move_toward(player.velocity.x , 0 , _acceleration * delta_time)

func jumping() -> void:
	var jump_strength = Input.get_action_strength("jump")
	var delta_time:float =  get_physics_process_delta_time()
	var jump_multiplier = 10.0
	
	if !player.is_on_floor():
		player.velocity.y += _gravity  * delta_time
	else:
		if jump_strength != 0:_anim_player.play("Jump")
		player.velocity.y = -_jump_force * jump_strength * jump_multiplier * delta_time


func flip(direction_flip:float) -> void:
	if !_sprite:
		return
	if direction_flip > 0:
		_sprite.flip_h = false
	elif direction_flip < 0:
		_sprite.flip_h = true




func _on_killed() -> void:
	state_machine.change_to("Dead")
