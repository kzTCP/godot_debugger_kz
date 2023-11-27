extends WindowDialog


var Json = preload("res://addons/kz_debugger/json.gd")
var kz_signal: kzJson


func _init():
	
	#print("Debugger init")
	#updates will be written here
	kz_signal = Json.new("res://addons/kz_debugger/json/signal.json")
	

func out(array_errors: Array):
	
	# get line number
	var stack = get_stack();	#printt("stack", stack)
	var obj = stack[1]
	var call_line = obj.line
	
	# get called script name
	var script_src: String = obj.source
	var startIndex = script_src.rfind("/")
	var script_name = script_src.substr(startIndex +1)
	
	var _expected_script_infos = "-> \t ({0}:{1})".format([script_name, call_line])

	var script_infos: String = "[color=#ff6969]([url={0}]{1}[/url]:{2})[/color]"
	
	
	var link = script_src + ":" + str(call_line)
	script_infos = script_infos.format([link, script_name, call_line])
	
	var obj_errors = {
		"array_errors": array_errors, 
		"call_line": call_line,
		"script_name": script_name,
		"script_src": script_src,
	}
	
	#print("out", obj_errors)
	# send object to plugin using json file and timer that looks for new data
	kz_signal.array_append(obj_errors)


