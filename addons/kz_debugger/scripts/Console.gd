extends WindowDialog


var Json = preload("res://addons/kz_debugger/scripts/json.gd")
var kz_signal: kzJson


func _init():
	
	#print("Debugger init")
	#updates will be written here
	kz_signal = Json.new( "res://addons/kz_debugger/json/signal.json")
	

func out(array_errors: Array):
	
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
	kz_signal.array_append({
		"array_errors": array_errors, 
		"call_line": call_line,
		"script_name": script_name,
		"script_src": script_src,
	})


