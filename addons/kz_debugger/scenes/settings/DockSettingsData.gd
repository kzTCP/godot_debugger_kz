class_name DockSettignsDataKZD extends Node


var json: kzJson
var json_default: kzJson


var use_separator: bool 
var top_bar_color: String
var src_color: String 
var size: Dictionary 
var min_size: Dictionary 


func _init(data: Dictionary = {}):
	

	if not data:
		
		use_separator = true
		top_bar_color = "#999999"
		src_color = "#faf223"
		size = VecTwo.to_obj(ConfigKZD.DOCK_SIZE)
		min_size =  VecTwo.to_obj(ConfigKZD.DOCK_SIZE)
		
	else:
		
		set_general_object(data)
		size = data.size
		min_size = data.min_size
	
	json  = kzJson.new( ConfigKZD.JSON_PATH + "dock_settings.json" )
	json_default = kzJson.new( ConfigKZD.JSON_PATH + "default.json" )
	
	

func get_general_object() ->  Dictionary:
	return {
		"use_separator": use_separator,
		"top_bar_color": top_bar_color,
		"src_color": src_color,
	}


func get_current_object() -> Dictionary:
	return {
		"size": size,
		"min_size": min_size,
	}

	
func set_general_object(data: Dictionary) -> void:
	
	use_separator = bool(data.use_separator)
	top_bar_color = str(data.top_bar_color)
	src_color = str(data.src_color)
	
	
func set_current_object(data: Dictionary) -> void:
	
	size = data.size
	min_size = data.min_size
	



func read() -> DockSettignsDataKZD:
	
	var settings = json.read()
	if not settings: return null
	var default = json_default.read()
	
	set_general_object(default)
	set_current_object(settings)
	
	return self;
	
	
func set_object(data: Dictionary):
	set_general_object(data)
	set_current_object(data)


func save() -> void:
	
	json.obj_append( get_current_object() )
	json_default.obj_append( get_general_object() )
	

func object() -> Dictionary:
	var obj = get_general_object()
	obj.merge( get_current_object())
	return obj
	
