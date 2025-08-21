tool
class_name DockSettingsKZD extends WindowDialog


var msgBoxScene = preload(
	"res://addons/kz_debugger/scenes/dialog/warningDialog.tscn"
)

var msgBox: kz_msgBox
var _settings_data: DockSettignsDataKZD


var _check_box: CheckBox 
var _size_x: LineEdit
var _size_y: LineEdit
var _min_size_x: LineEdit
var _min_size_y: LineEdit
var _top_bar_color: ColorPickerButton
var _source_color: ColorPickerButton


const SIZE: Vector2 = Vector2(550, 300)


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	
	if ConfigKZD.DEBUG: print("pressed")
		
	msgBox = msgBoxScene.instance()
	msgBox.title = "warning"
	msgBox.hide()
	
	#msgBox.get_close_button().connect("pressed", self, "_on_msg_box_close")
	add_child(msgBox)
	
	#get_close_button().connect("pressed", self, "_on_options_close")
	
	show()
	resizable = true
	
	_check_box = $VBoxContainer/HBoxContainer/inputs/Separator
	
	_top_bar_color = $VBoxContainer/HBoxContainer/inputs/HeaderColor
	_source_color = $VBoxContainer/HBoxContainer/inputs/LinkColor
	
	_size_x = $VBoxContainer/HBoxContainer/inputs/size/x_size
	_size_y = $VBoxContainer/HBoxContainer/inputs/size/y_size
	
	_min_size_x = $VBoxContainer/HBoxContainer/inputs/min_size/x_min_size
	_min_size_y = $VBoxContainer/HBoxContainer/inputs/min_size/y_min_size
	
	
	rect_size = SIZE
	rect_min_size = SIZE
	
	rect_position = (OS.window_size - rect_size)/2
	
	_settings_data = DockSettignsDataKZD.new()
	
	if ConfigKZD.DEBUG: print(_check_box, _top_bar_color)



func _get_settings_error_msg() -> String:
	
	var new_min_size = Vector2(
		int(_min_size_x.text),
		int(_min_size_y.text) 
	)
	
	var init_min_size = VecTwo.to_vect(_settings_data.min_size)
	
	var new_size = Vector2(
		int(_size_x.text),
		int(_size_y.text) 
	)


	var error_msg: String 
	if new_min_size.x >  OS.window_size.x or new_min_size.y >  OS.window_size.y:
		error_msg = "SIZE ERROR: min size = {0} out of UI range which's {1}".format([
			new_min_size, OS.window_size
		])
	elif (
		int(_size_x.text) >  OS.window_size.x or 
		int(_size_y.text) >  OS.window_size.y
	):
		error_msg = "SIZE ERROR: size = {0} out of UI range which's {1}".format([
			 Vector2( int(_size_x.text), int(_size_y.text) ), 
			OS.window_size
		])
	elif (new_size.x < init_min_size.x or new_size.y < init_min_size.y):
		error_msg = "SIZE ERROR: Min Size = {0} which doesn't fit Min size of DOCK = {1} ".format([
			init_min_size, new_size
		])
		
#	print(new_size , init_min_size)
		
	return error_msg



signal save
func _on_save_pressed():

	var error = _get_settings_error_msg()
	
	if error:
		msgBox.set_text(error)
		msgBox.set_type("ok")
		msgBox.show()
		return

	# save settings
	emit_signal("save", save_settings().object())
	queue_free()


func _on_cancel_pressed():
	_on_reset_pressed()
	queue_free()
	


func _on_default_pressed():
	
	init(DockSettignsDataKZD.new())
	
	
	
func apply_settings(data: DockSettignsDataKZD):
	
	_check_box.pressed = data.use_separator
	_size_x.text = str(data.size.x)
	_size_y.text = str(data.size.y)
	_min_size_x.text = str(data.min_size.x)
	_min_size_y.text = str(data.min_size.y)
	_top_bar_color.color = Color(data.top_bar_color )
	_source_color.color = Color(data.src_color )
	
	
func save_settings() -> DockSettignsDataKZD:
	
	_settings_data.use_separator = _check_box.pressed
	_settings_data.size = {
		"x": _size_x.text,
		"y": _size_y.text
	}
	_settings_data.min_size = {
		"x": _min_size_x.text,
		"y": _min_size_y.text
	}
	_settings_data.top_bar_color = _top_bar_color.color.to_html()
	_settings_data.src_color = _source_color.color.to_html()
	
	return _settings_data
	
	

func init(data: DockSettignsDataKZD):
	
	apply_settings(data)
	# save initial settings
	save_settings()
	
	
func _on_reset_pressed():
	apply_settings(_settings_data)


func only_numbers(string) -> String:
	var digit = ""
	if not str(string).is_valid_integer():
		for alpha in string:
			if not str(alpha).is_valid_integer(): continue
			digit += alpha;
	else:
		digit = string
	return digit


func handle_input(input: LineEdit, text: String):
	if not str(text).is_valid_integer():
		input.text = only_numbers(text)


func _on_x_size_text_changed(new_text):
	handle_input(_size_x, new_text)


func _on_y_size_text_changed(new_text):
	handle_input(_size_y, new_text)


func _on_x_min_size_text_changed(new_text):
	handle_input(_min_size_x, new_text)


func _on_y_min_size_text_changed(new_text):
	handle_input(_min_size_y, new_text)





