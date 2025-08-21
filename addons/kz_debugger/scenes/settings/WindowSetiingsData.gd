class_name WindowSettingsDataKZD extends DockSettignsDataKZD


var use_snap: bool
var snap: String
var snap_percentage: int
var snap_vector: Dictionary
var position: Dictionary


func _init(data: Dictionary = {}):

	._init(data)
	
	if not data:
		
		size	 = VecTwo.to_obj(ConfigKZD.WINDOW_SIZE)
		min_size = VecTwo.to_obj(ConfigKZD.WINDOW_SIZE)
		
		#additional settings
		use_snap 		= true
		snap 	 		= SnapKZD.CENTER
		snap_percentage = 70
		snap_vector 	= VecTwo.to_obj(ConfigKZD.WINDOW_SIZE)
		
		# idk why i added this ^_^
		position = VecTwo.to_obj(
			(OS.window_size - ConfigKZD.WINDOW_SIZE)/2
		)
		
	else:

		set_object(data)
	
	json  = kzJson.new( ConfigKZD.JSON_PATH + "window_settings.json" )


func get_current_object() ->  Dictionary:
	
	var obj = .get_current_object()
	obj.merge({
		"use_snap": use_snap,
		"snap": snap,
		"snap_percentage": snap_percentage,
		"snap_vector": snap_vector,
		"position": position,
	})
	return obj
	 
	
	
func set_current_object(data: Dictionary) -> void:
	
	.set_current_object(data)
	
	use_snap = data.use_snap
	snap = data.snap
	snap_percentage = data.snap_percentage
	snap_vector = data.snap_vector
	position = data.position
	
	
	
func object() -> Dictionary:
	
	var obj = .object()
	
	obj.merge( get_current_object() )

	return obj
	
	

