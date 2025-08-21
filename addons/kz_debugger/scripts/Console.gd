extends WindowDialog


const Json = preload("res://addons/kz_debugger/scripts/json.gd")
var json_signal: kzJson # auto created when first time using plugin
var json_default: kzJson

func _init():
	
	#print("Debugger init")
	#updates will be written here
	json_signal = Json.new( ConfigKZD.JSON_SIGNAL_PATH)
	json_default = Json.new( ConfigKZD.JSON_DEFAULT_PATH)
	


func out(array_errors: Array):
	
	# thi main reason export fails
	if not json_signal.exists(): return 
	
	
	# get line number
	var stack = get_stack();	#printt("stack", stack)
	var obj = stack[1]
	var call_line = obj.line
	
	# get called script name
	var script_src: String = obj.source
	var startIndex = script_src.rfind("/")
	var script_name = script_src.substr(startIndex +1)

	# send object to plugin using json file 
	# timer looks for new data in that one
	json_signal.array_append({
		"array_errors": array_errors, 
		"call_line": call_line,
		"script_name": script_name,
		"script_src": script_src,
	})


