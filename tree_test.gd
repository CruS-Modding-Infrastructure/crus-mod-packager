tool
extends Tree

func build():
	var tree = self
	var root = tree.create_item()
	root.set_text(0, "Rooot")
	#tree.hide_root = true
	var child1 = tree.create_item(root)
	var child2 = tree.create_item(root)
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
	var label = Label.new()
	print("AAAA")
