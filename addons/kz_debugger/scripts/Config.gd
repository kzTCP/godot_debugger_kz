class_name ConfigKZD extends Node



const DEBUG: bool = false

const DOCK_SIZE = Vector2(275, 200)
const WINDOW_SIZE = Vector2(500, 200)

const JSON_PATH = "res://addons/kz_debugger/json/"

const JSON_SIGNAL_PATH = JSON_PATH + "signal.json"
const JSON_DEFAULT_PATH = JSON_PATH + "default.json"
	
	
static func out(args: Array):
	
	var val = ""
	for index in args.size():
		var arg = args[index]
		val += str(arg)
		if index == args.size()-1: continue
		val += " "

	print(val)


