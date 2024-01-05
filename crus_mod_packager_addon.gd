tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/CruSModPackager-main/dock.tscn").instance()
	
	var config = ConfigFile.new()
	config.load("res://addons/CruSModPackager-main/plugin.cfg")
	var version:String = config.get_value("plugin", "version")
	var version_underscored = version.replace(".", "_")

	dock.name = "CruSModPackager V" + version_underscored
	
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)
	
	dock.version_info.text = "CruS Mod Packager version " + version
	
	dock.dock_init()

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
