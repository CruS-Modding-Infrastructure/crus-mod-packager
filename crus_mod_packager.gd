tool
extends Node

var dot_import_files:Array

#called from other script
func dock_init():
	if not _load_data():
		_save_data()
		_load_data()

func get_filelist(scan_dir : String, filter_exts : Array = []) -> Array:
	var my_files: Array = []
	var dir:Directory = Directory.new()
	if dir.open(scan_dir) != OK:
		printerr("[CruS mod packager]: Warning: could not open directory: ", scan_dir)
		return []
	
	print("[CruS mod packager]: Scanning " + scan_dir)
	
	if dir.list_dir_begin(true, true) != OK:
		printerr("[CruS mod packager]: Warning: could not list contents of: ", scan_dir)
		return []

	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			my_files += get_filelist(dir.get_current_dir() + "/" + file_name, filter_exts)
		else:
			if filter_exts.size() == 0:
				my_files.append(dir.get_current_dir() + "/" + file_name)
			else:
				for ext in filter_exts:
					if file_name.get_extension() == ext:
						my_files.append(dir.get_current_dir() + "/" + file_name)
		file_name = dir.get_next()
	return my_files

func get_dir_list(scan_dir):
	var dir = Directory.new()
	
	var dirs = [scan_dir]
	
	if dir.open(scan_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if file_name != "." and file_name != "..":
				if dir.current_is_dir():
					dirs += get_dir_list(scan_dir + "/" + file_name)
			file_name = dir.get_next()
		return dirs
	else:
		printerr("[CruS mod packager]: An error occurred when trying to access the path.")
		return []

func read_and_fetch_import(dot_import_file_path:String, output_path:String) -> void:
	var file:File = File.new()
	#open the .import file and store contents in string
	if file.open(dot_import_file_path, File.READ) != OK:
		printerr("[CruS mod packager]: Warning: Could not open file: ", dot_import_file_path)
		return
	var contents:String = file.get_as_text()
	file.close()
	#split the contents by every new line
	var content_split:PoolStringArray = contents.split("\n", false)
	#get the .import path line, assuming its always line 5 (3 new lines below line 1)
	var path_line:String = content_split[3]
	#remove path=" or path.s3tc=" or whatever else is in front of the path
	path_line = "res://" + path_line.get_slice("res://", 1)
	#remove the quotation mark from the end of line
	path_line.erase(path_line.length() -1, 1)
	#print info
	var file_name:String = dot_import_file_path.get_file()
	file_name.erase(file_name.length() -7, 7)
	print(file_name + " (" + path_line + ")")
	#copy the imported file to the selected directory
	var dir:Directory = Directory.new()
	#var new_path:String = dot_import_file_path.get_base_dir() + "/" + path_line.get_file()
	if dir.copy(path_line, "user://mods/" + modName.text + "/mod/.import/" + path_line.get_file()) != OK:
		printerr("[CruS mod packager]: Warning: Could not copy file: ", path_line, " user://mods/" + modName.text + "/mod/.import/")

onready var modName = $"%ModName"
onready var modAuthor = $"%ModAuthor"
onready var modVersion = $"%ModVersion"
onready var modDescription = $"%ModDescription"
onready var initFilePath = $"%InitPath"

onready var archiveModFolder = $"%ArchiveModFolder"
onready var launchCrus = $"%LaunchCrus"

onready var additionalFiles = $"%AdditionalFilesPath"
onready var crusPath = $"%CruSPath"

onready var sevenZipPath = $"%SevenZipPath"

onready var folder_path:LineEdit = $"%FolderPath"
onready var file_dialog:FileDialog = $"%FileDialog"
onready var info:Label = $"%Info"
onready var run_button:Button = $"%RunButton"

onready var trash_mod_folder:CheckBox = $"%TrashModFolder"
onready var version_info:Label = $"%VersionInfo"

func _on_RunButton_pressed():
	var dir:Directory = Directory.new()
	
	if modName.text == "":
		modName.text = "Test mod"
	
	if modAuthor.text == "":
		modAuthor.text = "Me"
	
	if modVersion.text == "":
		modVersion.text = "1.0"
	
	if modDescription.text == "":
		modDescription.text = "penis"
	
	dir.make_dir_recursive("user://mods/" + modName.text + "/mod")
	
	if dot_import_files.size() > 0 and validate_folder_path(folder_path.text):
		dir.make_dir_recursive("user://mods/" + modName.text + "/mod/.import")
		
		for file in dot_import_files:
			read_and_fetch_import(file, folder_path.text)
	
	var configData = {
		"name": modName.text,
		"author": modAuthor.text,
		"version": modVersion.text,
		"description": modDescription.text
	}
	
	if initFilePath.text != "":
		configData.init = initFilePath.text
	
	var configFile = File.new()
	configFile.open("user://mods/" + modName.text + "/mod.json", File.WRITE)
	configFile.store_string(to_json(configData))
	configFile.close()
	
	var files = get_filelist(folder_path.text)
	var dirs = get_dir_list(folder_path.text)
	
	for recivedDir in dirs:
		dir.make_dir_recursive("user://mods/" + modName.text + "/mod/" + recivedDir.get_slice("res://", 1))
	
	for file in files:
		dir.copy(file, "user://mods/" + modName.text + "/mod/" + file.get_slice("res://", 1))
	
	if OS.get_name() == "Windows":
		var output = []
		var zipPath = "\"" + ProjectSettings.globalize_path("res://addons/CruSModPackager-main/7z") + "/7za.exe\""
		
		if sevenZipPath.text != "":
			zipPath = "\"" + sevenZipPath.text + "/7z.exe\""
		
		if archiveModFolder.pressed:
			OS.execute("CMD.exe", ["/C", zipPath + " a -tzip \"" + ProjectSettings.globalize_path("user://mods/" + modName.text + "/mod.zip") + "\" \"" + ProjectSettings.globalize_path("user://mods/" + modName.text + "/mod/*\"")], true, output, true, true)
			if additionalFiles.text != "":
				OS.execute("CMD.exe", ["/C", zipPath + " a -tzip \"" + ProjectSettings.globalize_path("user://mods/" + modName.text + "/mod.zip") + "\" \"" + additionalFiles.text + "/*\""], true, output, true, true)
		if launchCrus.pressed:
			OS.execute("CMD.exe", ["/C", crusPath.text.substr(0,2) + " && cd \"" + crusPath.text + "\" && crueltysquad.exe && pause"], false, output, true, true)
	
	if trash_mod_folder.pressed:
		OS.move_to_trash(ProjectSettings.globalize_path("user://mods/" + modName.text + "/mod/"))
	
	#attempt to save data after packing mod
	_save_data()
	
	info.modulate = Color.green
	info.text = "Done! Check the output for details."
	
func _on_FileDialog_dir_selected(dir):
	if validate_folder_path(dir):
		find_import_files()
	
func _on_BrowseButton_pressed():
	validate_folder_path(folder_path.text)

func _on_FolderPath_text_entered(new_text):
	if validate_folder_path(new_text):
		find_import_files()

var check_dir:Directory = Directory.new()

func validate_folder_path(path:String) -> bool:
	if path == "" or path == "res://":
		reset_path()
		return false
	if check_dir.dir_exists(path):
		folder_path.text = path
		file_dialog.current_dir = path
		run_button.disabled = false
		return true
	else:
		reset_path()
		return false

func reset_path():
	run_button.disabled = true
	folder_path.text = ""
	file_dialog.current_dir = "res://"
	info.modulate = Color.white
	info.text = "Select a target folder."

func find_import_files():
	#get import files from the target folder and sub folders
	dot_import_files = get_filelist(folder_path.text, ["import"])
	
	if dot_import_files.size() <= 0:
		info.modulate = Color.yellow
		info.text = "No .import files found."
		return
	
	info.modulate = Color.green
	info.text = "Found (" + str(dot_import_files.size()) + ") .import files"

func _crus_folder_selected(dir):
	crusPath.text = dir

func _additional_files_folder_selected(dir):
	additionalFiles.text = dir

func _init_file_selected(file):
	initFilePath.text = file

func _sevenzip_folder_selected(dir):
	sevenZipPath.text = dir

func _save_data():
	var dir = Directory.new()
	if not dir.dir_exists("user://mod_config/"):
		dir.make_dir("user://mod_config/")
	
	var mod_config = File.new()
	mod_config.open("user://mod_config/CruSModPackager.save", File.WRITE)
	mod_config.store_line(to_json({
		"name": modName.text,
		"author": modAuthor.text,
		"version": modVersion.text,
		"description": modDescription.text,
		"modFolder": folder_path.text,
		"initFilePath": initFilePath.text,
		"crusPath": crusPath.text,
		"additionalFiles": additionalFiles.text,
		"archiveModFolder": archiveModFolder.pressed,
		"launchCrus": launchCrus.pressed,
		"sevenZipPath": sevenZipPath.text,
		"recycleModFolder": trash_mod_folder.pressed,
	}))
	mod_config.close()
	
	print("[CruS mod packager]: Saved")
	info.modulate = Color.green
	info.text = "Saved."

func _load_data() -> bool:
	
	var dir = Directory.new()
	if not dir.dir_exists("user://mod_config/"):
		dir.make_dir("user://mod_config/")

	var file = File.new()
	if file.file_exists("user://mod_config/CruSModPackager.save"):
		file.open("user://mod_config/CruSModPackager.save", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			modName.text = data.name
			modAuthor.text = data.author
			modVersion.text = data.version
			modDescription.text = data.description
			initFilePath.text = data.initFilePath
			
			folder_path.text = data.modFolder
			crusPath.text = data.crusPath
			additionalFiles.text = data.additionalFiles
			
			archiveModFolder.pressed = data.archiveModFolder
			launchCrus.pressed = data.launchCrus
			
			sevenZipPath.text = data.sevenZipPath
			
			trash_mod_folder.pressed = data.recycleModFolder
			
			_on_FolderPath_text_entered(data.modFolder)
			
			print("[CruS mod packager]: Loaded")
			info.modulate = Color.green
			info.text = "Loaded."
			return true
		else:
			printerr("[CruS mod packager]: Corrupted data!")
			info.modulate = Color.red
			info.text = "Corrupted data."
			return false
	else:
		printerr("[CruS mod packager]: No saved data!")
		info.modulate = Color.red
		info.text = "No saved data."
		return false

func _help_popup():
	$Popup.popup_centered()


func _on_DataFolder_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))


func _on_CruSCheck_pressed():
	var file = File.new()
	if file.file_exists("C:/Program Files (x86)/Steam/steamapps/common/Cruelty Squad/crueltysquad.exe"):
		crusPath.text = "C:/Program Files (x86)/Steam/steamapps/common/Cruelty Squad"
		info.modulate = Color.green
		info.text = "CruS was found!"
	else:
		info.modulate = Color.yellow
		info.text = "Couldn't find CruS."
