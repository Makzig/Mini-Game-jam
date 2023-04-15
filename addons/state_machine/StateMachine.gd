extends Node
class_name StateMachine


@export var inition_state := NodePath()
@onready var state := get_node(inition_state)

signal transition_to

func _ready() -> void:
	await owner
	for child in get_children():
		child.state_machine = self
	state.enter_state() 

func _process(delta:float):
	state.update(delta)

func _physics_process(delta:float):
	state.physics_update(delta)

func _unhandled_input(event:InputEvent):
	state.handless_input(event)

func change_to(state_name:String, state_needs:Dictionary = {}) -> void:
	if !has_node(state_name):
		return
	state.exit_state()
	state = get_node(state_name)
	state.enter_state(state_needs)
	transition_to.emit()
