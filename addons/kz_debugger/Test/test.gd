extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var kzStr = preload("res://addons/kz_debugger/core/KzStr.gd")
var j = preload("res://addons/kz_debugger/json.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	"""
	var json = j.new("res://addons/kz_debugger/json/signal.json")
	var loaded = json.read()
	if loaded:
		json.write({})
		
	var obj = {"h": 1}
	json.array_append(obj)
	json.array_append({"obj": 1})
	json.array_append({"2": 2})
	print(json.read())
	json.array_remove(obj)
	print(json.read())
	"""
	
	#"""
	
	console.out([kzStr.new("k").duplicate(1000), "kamal", "take it slow lee"])
	
	console.out(["i was wondering if you were mine 3alawi, will love these things", 
	"3alawi"])
	
	console.out(["i was wondering if you were mine 3alawi, will love these things", 
	"3alawi", "3alawi", "3alawi", "3alawi",
	"3alawi", "3alawi", "3alawi", "3alawi", 
	"3alawi", "3alawi", "3alawi", "3alawi",
	"3alawi", "3alawi", "3alawi", "3alawi", 
	"3alawi", "3alawi", "3alawi", "3alawi",
	 "3alawi", "3alawi", "3alawi", "3alawi"])
	
	console.out(["i was wondering if you were mine, 3alawi will love these things", 
	"3alawi"])
	
	console.out(["HELOO WORD"])
	#"""
	
	var obj = {"name": "name", "list": [1, 2, "hello", 3, 4], "string": "hello wolrd", 1: {"name": "name", 1: [1, 2,"hello", 3, 4], "string": "hello wolrd", "2": {"name": "name", "list": [1, 2, 3, 4], "string": "hello wolrd"}} }
	
	console.out([obj])
	#printt(kzStr.new("").obj_to_str(obj))
	
	var x= [1, "hello", obj]
	#printt(kzStr.new("").array_to_str(x))
	

	console.out(["hello world"])
	
	#printt("test.dg")
	#printt("local text")

	console.out(["gg brothers"])
	
	console.out(["gg \nbrothers\ngg"]) # nice bug hhhhhhh
	
	console.out(["gg \nbrothers fffffffffffffffffffffffffffffffffff"]) # nice bug hhhhhhh
	
	console.out(["gg \nbrothers fffffffffffff\nffffff\nfffffffff\nfffffffgggggggggggggggggggggggggggggggggggggggggggg"]) # nice bug hhhhhhh
	
	console.out([x])
	console.out(["x"])
	console.out([["x"]])
	console.out(["kk", ["x"]])
	
	#"""
	
	
	pass # Replace with function body.


