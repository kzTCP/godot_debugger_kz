class_name KzStr extends Object


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var text

func _init(txt):
	text = txt
	
	
func endsWith(ending: String) -> bool:
	
	var txt_lendth = text.length()
	var end_len = ending.length()
	
	if txt_lendth < end_len:
		return false
	
	var start = txt_lendth - end_len
	var substring = text.substr(start, end_len)
	
	return substring == ending


func duplicate(n: int):
	
	var x = ''
	for i in range(n):
		x += text
	return x
	
	
func is_object()-> bool:
	
	if not text is Dictionary:
		return false

	var p: JSONParseResult = JSON.parse(text)
	#print(JSON.print(p.result))
	#print(p.result is Dictionary, p.result is Object)
	var x = p.result is Dictionary
	return x
	
	
func get_object()-> Dictionary:
	var p: JSONParseResult = JSON.parse(text)
	#print(JSON.print(p.result))
	#print(p.result is Dictionary, p.result is Object)
	return p.result
	
	
func array_to_str(arr: Array)-> Array:
	#var result  = '['
	var result  = []
	#print("good")
	for item in arr:
		if item is Array:
			#result += array_to_str(item)
			result.append_array(array_to_str(item))
		elif item is Dictionary:
			result.append(obj_to_str(item))
		elif item is String:
			#result += '"{0}"'.format([item])
			result.append('"{0}"'.format([item]))
		else:
			#result += str(item)
			result.append(item)
			
		#result += ", "
	#result = result.left(result.length() - 2)
	#result += ']'
	#print("good")
	return result
	

func obj_to_str(obj: Dictionary) -> Dictionary:
	
	var obj_local = {}
	#var result = "{"
	
	for key in obj.keys():
		var value = obj[key]
		
		# Recursively convert nested dictionaries
		if value is Dictionary:
			value = obj_to_str(value)
			
		# Recursively convert arrays/lists
		elif value is Array:
			for i in range(value.size()):
				if value[i] is Dictionary:
					value[i] = obj_to_str(value[i])
					
		if key is String:

			if value is Dictionary:
				obj_local['"'+key+'"'] = value
				#result += '"%s": %s, ' % [key, (value)]
			elif value is Array:
				value = array_to_str(value)
				obj_local['"'+key+'"'] = value
				#result += '"%s": %s, ' % [key, (value)]
			elif value is String:
				obj_local['"'+key+'"'] = '"'+value+'"'
				#result += '"%s": "%s", ' % [key, (value)]
			else:
				obj_local['"'+key+'"'] = str(value)
		else:
			#var p: JSONParseResult = JSON.parse(str(value))
			#printt(p.result, value)
			#print(p.result is Dictionary, p.result is Object)
			
			if value is String:
				obj_local[key] = '"' + value + '"'
			elif value is Array:
				value = array_to_str(value)
				obj_local[key] = value
			else:
				#value is Dictionary
				obj_local[key] = value
	
	return obj_local


	

	
