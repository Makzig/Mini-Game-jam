extends Node
class_name State

var state_machine:StateMachine

func enter_state(_needs:Dictionary = {}) -> void:
	pass

func update(_delta:float) -> void:
	pass

func physics_update(_delta:float) -> void:
	pass

func handless_input(_event:InputEvent) -> void:
	pass

func exit_state() -> void:
	pass
