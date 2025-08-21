class_name kzJson extends Object


var _path: String
var debug: bool = false


func _init(path: String):
	_path = path


func write(data) -> void:
	
	if debug:  print("write", _path)
		
	var file = File.new()
	if not file.file_exists(_path): _create_file()
	
	file.open(_path, File.WRITE)
	
	file.store_string(
		JSON.print(data)
	)
	file.close()
	
		

func read() -> Dictionary:
	
	if debug: print("read", _path)
		
	var data
	
	var file = File.new()

	if file.file_exists(_path):
		file.open(_path, File.READ)
		data = JSON.parse(
			file.get_as_text()
		).result
		file.close()


	return data
	
	
func obj_append (dic: Dictionary) -> void:
	
	if debug: print("json.h obj_append")
		
	var saved_obj = read()
	if not saved_obj: saved_obj = {}
	
	for key in dic:
		# overwrite old values and add new ones
		saved_obj[key] = dic[key]

	write(saved_obj)
	
	
func _obj_compaire(obj1: Dictionary, obj2: Dictionary) -> bool:
	return str(obj1) == str(obj2)
	
	
	
const KEY = "array"	
func array_write(array: Array):
	
	var file = File.new()
	file.open(_path, File.WRITE)
	file.store_string( 
		JSON.print( { KEY: array } ) 
	)
	file.close()


func array_read() -> Array:
	
	if debug: print("json.h array_read")
		
	var file = File.new()
	file.open(_path, File.READ)
	
	var obj = JSON.parse(file.get_as_text()).result
	
#	print(obj)
	var array = []
	if obj is Dictionary && KEY in obj && obj[KEY] is Array:
		array = obj[KEY]
	file.close()
	return array
	


func array_append(obj: Dictionary) -> void:
	
	if debug: print("json.h array_append")	
		
	var array: Array
	
	array = array_read() if array_read() else  []
	
	array.append(obj)

	array_write(array)
	

	
func array_remove(obj: Dictionary) -> void:
	
	if debug: print("json.h array_remove")
		
	var array: Array = array_read() if array_read() else []
	
	if not array and debug:
		print("json array_remove array is empty")
		return
		
	var removed = false
	var new_array = []
	for current_obj in array:
		#compare the string vertion of object
		if not _obj_compaire(current_obj, obj):
			new_array.append(current_obj)
		else:
			removed = true
			
	if not removed and debug: 
		print("json array_remove not removed");
		return
	
	array_write(new_array)


func clear() -> void:
	
	if debug: print("json.h clear")
		
	write({})
	
	
var _dir = Directory.new()
func exists():
	return _dir.file_exists(_path)
	
	
func _create_file():
	

	# Extract directory and file
	var directory_path = _path.get_base_dir()
	var file_name = _path.get_file()

	# Create the directory if it doesn't exist
	if not _dir.dir_exists(directory_path):
		var err = _dir.make_dir_recursive(directory_path)
		if err != OK:
			push_error("❌ Failed to create directory: " + directory_path)
			return


	# Create the file if it doesn't exist
	if not _dir.file_exists(_path):
		var file = File.new()
		var err = file.open(_path, File.WRITE)
		if err != OK:
			push_error("❌ Failed to create file: " + _path)
			return
		file.store_string("")  # Write empty content
		file.close()
	else:
		print("⚠️ File already exists:", _path)
