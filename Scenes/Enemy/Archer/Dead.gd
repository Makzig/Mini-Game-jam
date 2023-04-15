extends State


func enter_state(_need:Dictionary = {}) -> void:
	owner.queue_free()
