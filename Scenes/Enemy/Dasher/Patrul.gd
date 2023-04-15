extends State


##Onready and enter state
@export_node_path("AnimatedSprite2D") var anim_sprite 
@export_node_path("HurtBox2D") var hurtbox

@onready var _health_box:HurtBox2D = get_node(hurtbox)
@onready var _animade_sprite:AnimatedSprite2D = get_node(anim_sprite)
@onready var _ray_detect:RayCast2D = $Rays/PlayerDetect

var _player

var _move_speed:float = 1500.0
var direction:int = 1




func enter_state(_need:Dictionary = {}) -> void:
	_player = owner as CharacterBody2D
	_health_box.killed.connect(_on_killed)

func exit_state() -> void:
	_health_box.killed.disconnect(_on_killed)

func physics_update(_delta:float) -> void:
	movement()
	if _player.is_on_wall() :
		flip_to_h()
	if _ray_detect.is_colliding():
		if _ray_detect.get_collider().is_in_group("Player"):
			state_machine.change_to("Dash")
	


func movement() -> void:
	var delta_time = get_physics_process_delta_time()
	_player.velocity.x = _move_speed * delta_time * direction
	if !_player.is_on_floor():_player.velocity.y += 1000.0 * delta_time
	_player.move_and_slide()

func flip_to_h() -> void:
	if _animade_sprite:_animade_sprite.flip_h = !_animade_sprite.flip_h
	direction *= -1
	_ray_detect.target_position.x *= -1


func _on_killed() -> void:
	state_machine.change_to("Dead")
