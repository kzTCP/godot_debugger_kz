class_name kzJson extends Object


var _path: String
var debug: bool = false


func _init(path: String):
	_path = path


func write(var thing_to_save) -> void:
	
	if debug: 
		print("json.h")
		print("write")
		
	var file = File.new()
	if file.file_exists(_path):
		file.open(_path, File.WRITE)
		file.store_var(thing_to_save)
		file.close()
		

func read() -> Dictionary:
	if debug: 
		print("json.h")
		print("read")
		
	var theDict
	
	var file = File.new()

	if file.file_exists(_path):
		file.open(_path, File.READ)
		theDict = file.get_var()
		file.close()

	return theDict
	

func obj_append (var dic: Dictionary) -> void:
	
	if debug: 
		print("json.h")
		print("obj_append")
		
	var saved_obj = read()
	if not saved_obj: 
		saved_obj = {}
	
	for key in dic:
		# overwrite old values and add new ones
		saved_obj[key] = dic[key]

	write(saved_obj)
	
	
func array_read() -> Array:
	
	if debug: 
		print("json.h")
		print("array_read")
		
	var file = File.new()
	file.open(_path, File.READ)
	var array = file.get_var()
	file.close()
	return array


func array_append(var obj: Dictionary) -> void:
	
	if debug: 
		print("json.h")
		print("array_append")	
		
	var array = array_read()
	if not array: array = []
	array.append(obj)

	var file = File.new()
	file.open(_path, File.WRITE)
	file.store_var(array)
	file.close()
	
	
func _obj_compaire(obj1: Dictionary, obj2: Dictionary) -> bool:
	return str(obj1) == str(obj2)
	
	
func array_remove(var obj: Dictionary) -> void:
	
	if debug: 
		print("json.h")
		print("array_remove")
		
	var array: Array = array_read()
	
	if not array and debug:
		print("json array_remove array is empty")
		return
		
	var removed = false
	var new_array = []
	for local_obj in array:
		#compare the string vertion of object
		if not _obj_compaire(local_obj, obj):
			new_array.append(local_obj)
		else:
			removed = true
			
	if not removed and debug: 
		print("json array_remove not removed");
		return
	
	var file = File.new()
	file.open(_path, File.WRITE)
	file.store_var(new_array)
	file.close()



func clear() -> void:
	
	if debug: 
		print("json.h")
		print("clear")
		
	var file = File.new()
	file.open(_path, File.WRITE)
	file.store_var({})
	file.close()
