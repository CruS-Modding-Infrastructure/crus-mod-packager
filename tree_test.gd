tool
extends Tree

func build():
	print(get_dir_list("res://"))
	
	var tree = self
	var root = tree.create_item()
	root.set_text(0, "res://")
	
	#tree.hide_root = true
	var child1 = tree.create_item(root)
	
	var child2:TreeItem = tree.create_item(root)
	
	child2.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
	
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
	
func get_dir_list(scan_dir):
	var dir = Directory.new()
	
	var dirs = [scan_dir]
	
	if dir.open(scan_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if file_name != "." and file_name != ".." and file_name != ".git" and file_name != "addons":
				
				if dir.current_is_dir():
					dirs += get_dir_list(scan_dir + "/" + file_name)
				
			file_name = dir.get_next()
		return dirs
	else:
		printerr("[CruS mod packager]: An error occurred when trying to access the path.")
		return []
