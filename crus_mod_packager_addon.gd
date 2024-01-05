tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/CruSModPackager-main/dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)
	
	dock.dock_init()

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
