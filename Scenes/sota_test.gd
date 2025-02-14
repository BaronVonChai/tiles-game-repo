@tool
extends EditorScript

func _run():


	# Check for classes that might be related to Sota
	var possible_prefixes = ["Sota", "HexMap", "HexGrid", "HexTile"]
	
	for prefix in possible_prefixes:
		var class_list = ClassDB.get_class_list()
		for i in range(class_list.size()):
			var class_name_str = class_list[i]
			if class_name_str.begins_with(prefix):
				print("Found relevant class: ", class_name_str)
				
				# List methods
				var methods = ClassDB.class_get_method_list(class_name_str)
				for method in methods:
					print("  - Method: ", method.name)
	
	# Also check for global singletons
	if Engine.has_singleton("Sota"):
		print("Found Sota singleton!")
		var sota = Engine.get_singleton("Sota")
		print_methods_of_object(sota)

func print_methods_of_object(obj):
	# Get all methods of an object using reflection
	var methods = obj.get_method_list()
	for i in range(methods.size()):
		print("  - Method: ", methods[i]["name"])
