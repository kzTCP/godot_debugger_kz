tool
class_name WindowSettingsKZD extends DockSettingsKZD


var _snap_option: OptionButton
var _snap_percentage: LineEdit 
var _snap_val_x: LineEdit
var _snap_val_y: LineEdit
var _use_snap_mode: CheckBox 



static func get_default_settings() -> Dictionary:
	var obj = .get_default_settings()
	
	#overwrite this
	obj["size"] = VecTwo.to_obj(ConfigKZD.WINDOW_SIZE)
	obj["min_size"] = VecTwo.to_obj(ConfigKZD.WINDOW_SIZE)
	
	#additional settings
	obj["use_snap"] = true
	obj["snap"] = SnapKZD.CENTER
	obj["snap_percentage"] = 70
	obj["snap_vector"] = VecTwo.to_obj(ConfigKZD.WINDOW_SIZE)
	# idk why i added this ^_^
	obj['position'] = VecTwo.to_obj(
		(OS.window_size - ConfigKZD.WINDOW_SIZE)/2
	)
	return obj
	

func _enter_tree():
	
	._enter_tree()
	
	_use_snap_mode = $VBoxContainer/HBoxContainer/inputs/snap_mode
	_snap_option = $VBoxContainer/HBoxContainer/inputs/OptionButton
	_snap_percentage = $VBoxContainer/HBoxContainer/inputs/snap_percentage
	_snap_val_x = $VBoxContainer/HBoxContainer/inputs/snap_val/snap_x
	_snap_val_y = $VBoxContainer/HBoxContainer/inputs/snap_val/snap_y


	
func _get_settings_error_msg() -> String:
	
	var error_msg: String = ._get_settings_error_msg()
	
	if error_msg: return error_msg
	
	var value_to_cmp: int
	var snap_val: int
	var constant_side = ""
	var snap_per: int =  int(_snap_percentage.text)
	var win_x = OS.window_size.x
	var win_y = OS.window_size.y
	
	var new_min_size = Vector2(
		int(_min_size_x.text),
		int(_min_size_y.text) 
	)

	if _snap_option.text in [SnapKZD.LEFT, SnapKZD.RIGHT]:
		value_to_cmp = new_min_size.x# const width
		snap_val = int(_snap_val_x.text)
		constant_side = "x"
	else:
		value_to_cmp = new_min_size.y # const height
		snap_val = int(_snap_val_y.text)
		constant_side = "y"
		
	var error_type = "SIZE ERROR:"
	
	if value_to_cmp > snap_val:
		error_msg = "{0} snap value = {1} should be greater or equals (>=) to the min size {2} which equals {3}".format([
			error_type, snap_val, constant_side, value_to_cmp
		])
	elif constant_side == "x" and _use_snap_mode.pressed:
		if snap_val > OS.window_size.x:
			error_msg = "{0} x axis of snap value= {1} out of UI x axis range which's {2}".format([
				error_type, snap_val, OS.window_size.x
			])
		elif win_y * snap_per/ 100 < new_min_size.y:
			error_msg = "{0} snap percentage * windows height / 100 = {1} which's less than min size y = {2}".format([
				error_type, int(win_y * snap_per/ 100), new_min_size.y
			])
	elif constant_side == "y" and _use_snap_mode.pressed:
		if snap_val > OS.window_size.y:
			error_msg = "{0} y axis of snap value = {1} out of UI x axis range which's {2}".format([
				error_type, snap_val, OS.window_size.y
			])
		elif win_x * snap_per/ 100 < new_min_size.x:
			error_msg = "{0} snap percentage * windows width / 100 = {1} which's less than min size x = {2}".format([
				 error_type, int(win_x * snap_per/ 100), new_min_size.x
			])

	return error_msg


func get_index_options_btn(
	option_button: OptionButton, 
	search_val: String
) -> int:
	
	var count = option_button.get_item_count( )
	for i in range(count):
		if option_button.get_item_text(i) == search_val: return i
	return -1


func load_data(obj: Directory):
	
	var snap_index = get_index_options_btn(_snap_option, obj["snap"])
	_snap_option.select(snap_index)
	
	_snap_percentage.text = str(obj["snap_percentage"])
	_snap_val_x.text = str(obj["snap_vector"].x)
	_snap_val_y.text = str(obj["snap_vector"].y)
	_use_snap_mode.pressed = obj["use_snap"]


func _on_snap_percentage_text_changed(new_text):
	
	var digit: int
	if not str(new_text).is_valid_integer():
		 digit = int(only_numbers(new_text))
	else:
		digit = int(new_text)
		
	if not (0 <= digit and digit <= 100):
		_snap_percentage.text = str(new_text).left(new_text.length()-1)


func _on_snap_x_text_changed(new_text):
	handle_input(_snap_val_x, new_text)


func _on_snap_y_text_changed(new_text):
	handle_input(_snap_val_y, new_text)


func set_settings(obj: Dictionary):
	
	.set_settings(obj)
	
	_use_snap_mode.pressed = bool(obj["use_snap"])
	_snap_option.text = obj["snap"]
	_snap_percentage.text = str(obj["snap_percentage"])
	_snap_val_x.text = str(obj["snap_vector"].x)
	_snap_val_y.text = str(obj["snap_vector"].y)


func object():
	
	var obj = .object()
	
	obj["use_snap"] = _use_snap_mode.pressed
	obj["snap"] = _snap_option.text
	obj["snap_percentage"] = _snap_percentage.text
	obj["snap_vector"] = {"x": _snap_val_x.text, "y": _snap_val_y.text}

	return obj
	
	
