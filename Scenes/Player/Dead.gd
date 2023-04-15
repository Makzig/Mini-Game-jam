extends State


func enter_state(_need:Dictionary = {}) -> void:
	EventBus.killed.emit()
