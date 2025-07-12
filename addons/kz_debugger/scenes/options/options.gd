tool
class_name kz_options extends WindowDialog


var msgBoxScene = preload("res://addons/kz_debugger/scenes/dialog/warningDialog.tscn")


var use_separator : bool = false
var _old_obj = {}
var _check_box: CheckBox 
var _bottom_bar: HBoxContainer
var _border: Vector2 = Vector2(8, 8)
var _size: Vector2 = Vector2(525, 275)
var _resolutin_x: LineEdit
var _resolutin_y: LineEdit
var _min_size_x: LineEdit
var _min_size_y: LineEdit
var _snap_option: OptionButton
var _snap_percentage: LineEdit 
var _snap_val_x: LineEdit
var _snap_val_y: LineEdit
var _top_bar_color: ColorPickerButton
var _source_color: ColorPickerButton
var _use_snap_mode: CheckBox 

var msgBox: kz_msgBox

var win_size: Vector2
	
	
# Called when the node enters the scene tree for the first time.
func _enter_tree():
	
	msgBox = msgBoxScene.instance()
	msgBox.title = "warning (kzdebugger)"
	msgBox.hide()
	#msgBox.get_close_button().connect("pressed", self, "_on_msg_box_close")
	add_child(msgBox)
	
	#get_close_button().connect("pressed", self, "_on_options_close")
	
	window_title = "settings (kzdebugger)"
	show()
	resizable = true
	
	_check_box = $VBoxContainer/HBoxContainer/VBoxContainer/CheckBox
	_resolutin_x = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/res_x
	_resolutin_y = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/res_y
	_bottom_bar = $bottom_bar
	_snap_option = $VBoxContainer/HBoxContainer/VBoxContainer/OptionButton
	_snap_percentage = $VBoxContainer/HBoxContainer/VBoxContainer/snap_percentage
	_snap_val_x = $VBoxContainer/HBoxContainer/VBoxContainer/snap_val/snap_x
	_snap_val_y = $VBoxContainer/HBoxContainer/VBoxContainer/snap_val/snap_y
	_top_bar_color = $VBoxContainer/HBoxContainer/VBoxContainer/topbarColor
	_source_color = $VBoxContainer/HBoxContainer/VBoxContainer/source_color
	
	_min_size_x = $VBoxContainer/HBoxContainer/VBoxContainer/min_size/min_x
	_min_size_y = $VBoxContainer/HBoxContainer/VBoxContainer/min_size/min_y
	_use_snap_mode = $VBoxContainer/HBoxContainer/VBoxContainer/snap_mode
	
	rect_size = _size
	rect_min_size =_size

	_old_obj["use_separator"] = bool(use_separator)
	_old_obj["size"] = {"x": rect_size.x, "y": rect_size.y }
	_old_obj["min_size"] = {"x": 500, "y": 200 }
	_old_obj["use_snap"] = _use_snap_mode.pressed
	_old_obj["snap"] = _snap_option.text
	_old_obj["snap_percentage"] = _snap_percentage.text
	_old_obj["snap_x"] = _snap_val_x.text
	_old_obj["snap_y"] = _snap_val_y.text
	_old_obj["top_bar_color"] = _top_bar_color.color
	_old_obj["src_color"] = _source_color.color
	

	_bottom_bar.rect_position
	
	#print(_bottom_bar.rect_position)
	
	win_size = OS.window_size
	
	rect_position = (win_size - rect_size)/2


func _on_CheckBox_pressed():
	use_separator = _check_box.pressed

var min_size: Vector2 = Vector2(500, 200)

signal _on_apply_btn_pressed
func _on_apply_pressed():
	
	var value_to_cmp: int
	var snap_val: int
	var constant_side = ""
	var snap_per: int =  int(_snap_percentage.text)
	var min_x = int(_min_size_x.text) 
	var min_y = int(_min_size_y.text) 
	var win_x = OS.window_size.x
	var win_y = OS.window_size.y
	var op_min_size = Vector2(min_x, min_y)
	var error_msg: String 

	if _snap_option.text in ["left", "right"]:
		value_to_cmp = int(_min_size_x.text)# const width
		snap_val = int(_snap_val_x.text)
		constant_side = "x"
	else:
		value_to_cmp = int(_min_size_y.text) # const height
		snap_val = int(_snap_val_y.text)
		constant_side = "y"
	
	if value_to_cmp > snap_val:
		error_msg = "SIZE ERROR: snap value = {0} should be greater or equals (>=) to the min size {1} which equals {2}".format([snap_val, constant_side, value_to_cmp])
	elif constant_side == "x" and _use_snap_mode.pressed:
		if snap_val > OS.window_size.x:
			error_msg = "SIZE ERROR: x axis of snap value= {0} out of UI x axis range which's {1}".format([snap_val, OS.window_size.x])
		elif win_y * snap_per/ 100 < min_y:
			var size_y = int(win_y * snap_per/ 100)
			error_msg = "SIZE ERROR: snap percentage * windows height / 100 = {0} which's less than min size y = {1}".format([size_y, min_y])
	elif constant_side == "y" and _use_snap_mode.pressed:
		if snap_val > OS.window_size.y:
			error_msg = "SIZE ERROR: y axis of snap value = {0} out of UI x axis range which's {1}".format([snap_val, OS.window_size.y])
		elif win_x * snap_per/ 100 < min_x:
			var size_x = int(win_x * snap_per/ 100)
			error_msg = "SIZE ERROR: snap percentage * windows width / 100 = {0} which's less than min size x = {1}".format([size_x, min_x])
	elif min_x >  OS.window_size.x or min_y >  OS.window_size.y:
		error_msg = "SIZE ERROR: min size = {0} out of UI range which's {1}".format([op_min_size, OS.window_size])
	elif int(_resolutin_x.text) >  OS.window_size.x or int(_resolutin_y.text) >  OS.window_size.y:
		var _rect_size = Vector2(int(_resolutin_x.text), int(_resolutin_y.text))
		error_msg = "SIZE ERROR: size = {0} out of UI range which's {1}".format([_rect_size, OS.window_size])
	elif op_min_size.x < min_size.x or op_min_size.y < min_size.y:
		error_msg = "SIZE ERROR: Min Size = {0} which doesn't fit Min size of DOCK = {1} ".format([min_size, Vector2(275, 200)])
		
	if error_msg:
		msgBox.set_text(error_msg)
		msgBox.set_type("ok")
		msgBox.show()
		return
		
	#print("min_size", min_size, min_size < Vector2(250, 200))

	emit_signal("_on_apply_btn_pressed", object())
	queue_free()


func _on_cancel_pressed():
	_on_reset_pressed()
	queue_free()


func get_index_options_btn(option_button: OptionButton, search_val: String) -> int:
	
	var count = option_button.get_item_count( )
	for i in range(count):
		var val = option_button.get_item_text(i)
		if val == search_val:
			return i
	return -1


func object():
	return {
		"use_separator": _check_box.pressed,
		"size": {"x": _resolutin_x.text, "y": _resolutin_y.text },
		"min_size": {"x": _min_size_x.text, "y": _min_size_y.text },
		"snap": _snap_option.text,
		"snap_percentage": _snap_percentage.text,
		"snap_x": _snap_val_x.text,
		"snap_y": _snap_val_y.text,
		"top_bar_color": _top_bar_color.color,
		"src_color": _source_color.color,
		"use_snap": _use_snap_mode.pressed,
	}


func _on_reset_pressed():
	
	_check_box.pressed = _old_obj["use_separator"]
	
	_resolutin_x.text = str(_old_obj["size"].x)
	_resolutin_y.text = str(_old_obj["size"].y)
	_min_size_x.text = str(_old_obj["min_size"].x)
	_min_size_y.text = str(_old_obj["min_size"].y)
	
	var snap_index = get_index_options_btn(_snap_option, _old_obj["snap"])
	_snap_option.select(snap_index)
	
	_snap_percentage.text = str(_old_obj["snap_percentage"])
	_snap_val_x.text = str(_old_obj["snap_x"])
	_snap_val_y.text = str(_old_obj["snap_y"])
	_top_bar_color.color = _old_obj["top_bar_color"] 
	_source_color.color = _old_obj["src_color"]
	_use_snap_mode.pressed = _old_obj["use_snap"]
	

func init(obj):
	
	_check_box.pressed = obj["use_separator"]
	
	_resolutin_x.text = str(obj["size"].x)
	_resolutin_y.text = str(obj["size"].y)
	
	_min_size_x.text = str(obj["min_size"].x)
	_min_size_y.text = str(obj["min_size"].y)
	
	var snap_index = get_index_options_btn(_snap_option, obj["snap"])
	_snap_option.select(snap_index)

	_snap_percentage.text = str(obj["snap_percentage"])
	_snap_val_x.text = str(obj["snap_x"])
	_snap_val_y.text = str(obj["snap_y"])
	
	_top_bar_color.color = Color(obj["top_bar_color"])
	_source_color.color = Color(obj["src_color"])
	_use_snap_mode.pressed = obj["use_snap"]
	
	_old_obj = object()# save data


func only_numbers(string):
	var digit = ""
	if not str(string).is_valid_integer():
		for alpha in string:
			if str(alpha).is_valid_integer():
				digit += alpha;
	else:
		digit = string
	return digit


func _on_res_x_text_changed(new_text):
	if not str(new_text).is_valid_integer():
		_resolutin_x.text = only_numbers(new_text)


func _on_res_y_text_changed(new_text):
	if not str(new_text).is_valid_integer():
		_resolutin_y.text = only_numbers(new_text)


func _on_snap_percentage_text_changed(new_text):
	
	var digit
	if not str(new_text).is_valid_integer():
		 digit = int(only_numbers(new_text))
	else:
		digit = int(new_text)
		
	if not (0 <= digit and digit <= 100):
		_snap_percentage.text = str(new_text).left(new_text.length()-1)


func _on_min_x_text_changed(new_text):
	if not str(new_text).is_valid_integer():
		_min_size_x.text = only_numbers(new_text)


func _on_min_y_text_changed(new_text):
	if not str(new_text).is_valid_integer():
		_min_size_y.text = only_numbers(new_text)


func _on_snap_x_text_changed(new_text):
	if not str(new_text).is_valid_integer():
		_snap_val_x.text = only_numbers(new_text)


func _on_snap_y_text_changed(new_text):
	if not str(new_text).is_valid_integer():
		_snap_val_y.text = only_numbers(new_text)


func dock_settings():
	
	var list_variants = [
		_resolutin_x, _resolutin_y, _snap_option, _use_snap_mode,
		_snap_percentage, _snap_val_x, _snap_val_y
	]
	
	var label_resolutin_x = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/x
	var label_resolutin_y = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/y
	var label_resolution = $VBoxContainer/HBoxContainer/VBoxContainer2/resolution
	var label_snap_option = $VBoxContainer/HBoxContainer/VBoxContainer2/snap
	var label_snap_percentage = $VBoxContainer/HBoxContainer/VBoxContainer2/snap_percentage
	var label_use_snap_mode = $VBoxContainer/HBoxContainer/VBoxContainer2/use_snap_mode
	var label_snap_val_x = $VBoxContainer/HBoxContainer/VBoxContainer/snap_val/x
	var label_snap_val_y = $VBoxContainer/HBoxContainer/VBoxContainer/snap_val/y
	var label_snap_val =  $VBoxContainer/HBoxContainer/VBoxContainer2/snap_val
	
	var list_labels = [
		label_resolutin_x, label_resolutin_y, label_resolution,
		label_snap_option, label_snap_percentage, label_use_snap_mode,
		label_snap_val_x, label_snap_val_y, label_snap_val
	]
	
	list_variants.append_array(list_labels)
	
	for variant in list_variants:
		variant.hide()

