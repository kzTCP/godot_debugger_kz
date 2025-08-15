extends Control


var kzStr = preload("res://addons/kz_debugger/scripts/KzStr.gd")
var j = preload("res://addons/kz_debugger/scripts/json.gd")


func _ready():

	
	console.out([kzStr.new("k").duplicate(1000), "kamal", "take it slow lee"])

	console.out([
		"i was wondering if you were mine 3alawi, will love these things", 
		"3alawi"
	])

	console.out([
		"i was wondering if you were mine 3alawi, will love these things", 
		"3alawi", "3alawi", "3alawi", "3alawi",
		"3alawi", "3alawi", "3alawi", "3alawi", 
		"3alawi", "3alawi", "3alawi", "3alawi",
		"3alawi", "3alawi", "3alawi", "3alawi", 
		"3alawi", "3alawi", "3alawi", "3alawi",
		 "3alawi", "3alawi", "3alawi", "3alawi"
	])

	console.out(["i was wondering if you were mine, 3alawi will love these things", 
	"3alawi"])

	console.out(["HELOO WORD"])
	#"""

	var obj = {"name": "name", "list": [1, 2, "hello", 3, 4], "string": "hello wolrd", 1: {"name": "name", 1: [1, 2,"hello", 3, 4], "string": "hello wolrd", "2": {"name": "name", "list": [1, 2, 3, 4], "string": "hello wolrd"}} }

	console.out([obj])
	#printt(kzStr.new("").obj_to_str(obj))

	var x = [1, "hello", obj]
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
	
	console.out([20, 32, 20, 20, "ghjghj"])
	
	
