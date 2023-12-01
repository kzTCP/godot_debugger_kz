tool
extends Control

# case of text problem:
# update reseved_width variable
#

var _top_bar_h: float  = 25
var _tab_spaces: String = ''
var _expected_script_infos: String = ''
var _txt_max_width: float
var _gap = "    "
var _copyright: String
var _border = Vector2(4, 4)
var _scroll_bar_width: float = 9
var _reserved_copyright_space: float

var _RichTextLabel: RichTextLabel
var _text_bg_color: ColorRect
var _src_hexa_color: String
var _top_bar_col: ColorRect
var _HBoxContainer: HBoxContainer
var _clear_btn: Button
var _snap_percentage: int = 70
var _snap_vec: Vector2 = Vector2(500, 200)

var test_mode: bool = false
var os_size = OS.window_size


var json_goto: kzJson
var json_default: kzJson
var json_dock: kzJson
var kz_signal: kzJson

var options_menu: kz_options

var kzStr = preload("res://addons/kz_debugger/core/KzStr.gd")
var Json = preload("res://addons/kz_debugger/json.gd")
var options_menu_scene = preload("res://addons/kz_debugger/options/options.tscn")

var _error_width_range: float = 8
# example
var options_obj = {
	"use_separator": true,
	"size": {"x": 500, "y": 200},
	"dock_min_size": {"x": 275, "y": 200},
	"snap": "center",
	"snap_percentage": _snap_percentage,
	"snap_x": _snap_vec.x,
	"snap_y": _snap_vec.y,
	"top_bar_color": "#999999",
	"src_color": "#faf223",
	"use_snap": false,
	"dock": {"type": "control"},
}


var debug: bool = false


func _set_tab_spaces():
	#generate tab spaces
	for i in range(_RichTextLabel.tab_size):
		_tab_spaces += ' '


func _structure():
	
	_top_bar_col = $topBarCol
	_HBoxContainer = $HBoxContainer
	_clear_btn =  $HBoxContainer/clear
	
	_text_bg_color = $text_bg_color
	_RichTextLabel = $RichTextLabel
	
	_top_bar_col.color = Color(options_obj.top_bar_color)
	_src_hexa_color = Color(options_obj.src_color).to_html()
	_RichTextLabel.bbcode_enabled = true
	_RichTextLabel.selection_enabled = true
	_RichTextLabel.scroll_following = true
	
	_copyright = "[center][color=gray]---- kzCode_ Debugger ----[/color][/center]\n"
	_RichTextLabel.bbcode_text = _copyright


func _window_resize(window_size: Vector2):
	
	var local_debug:bool = false
	if local_debug and debug:
		print("->\tdebug_dock.gd")
		print("_window_resize")
		
	_txt_max_width = window_size.x
	
	#printt("_window_resize()")
	#printt("window_size", window_size)
	
	var top_bar_size = Vector2(_txt_max_width, _top_bar_h) 
	
	_top_bar_col.rect_size = top_bar_size
	_HBoxContainer.rect_size = top_bar_size
	
	#_clear_btn.rect_size.y = _top_bar_h - _border.y * 2
	_top_bar_col.rect_size.y = _clear_btn.rect_size.y
	
	var text_y = window_size.y - _top_bar_h 
	var text_area_size = Vector2(_txt_max_width, text_y) 
	
	_text_bg_color.rect_size = text_area_size
	_text_bg_color.rect_position.y = _top_bar_h 
	
	_RichTextLabel.rect_size = text_area_size
	_RichTextLabel.rect_position.y = _top_bar_h
	
	#printt("rect_size", rect_size)
	#printt("end _window_size()")


var default_pos: Vector2
func _enter_tree():
	
	if debug:
		printt("->\tdebug_dock.gd")
		print("_enter_tree")
		
	_error_width_range = txt_size(":52)").x
	
	json_goto = Json.new("res://addons/kz_debugger/json/goto.json")
	json_default = Json.new("res://addons/kz_debugger/json/default.json")
	json_dock = Json.new("res://addons/kz_debugger/json/dock.json")
	kz_signal = Json.new("res://addons/kz_debugger/json/signal.json")
	
	var obj = json_default.read()
	#var win_y = OS.window_size.y
	#set default size
	#print(obj)
	
	if obj:
		
		if "dock_min_size" in obj: 
			options_obj = obj #overwrite 
			
		var x = int(options_obj.dock_min_size.x)
		var y = int(options_obj.dock_min_size.y)
		rect_min_size.x = x
		rect_size.x =x
		
	else:
		
		rect_min_size.x = 500 
		rect_size.x = 500 

	_structure()
	
	_set_tab_spaces()
	
	_window_resize(rect_size)
	
	#updating only min size update resolution
	options_obj["dock_min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
	#options_obj["position"] = {"x": rect_position.x, "y": rect_position.y}
	#options_obj["size"] = {"x": rect_size.x, "y": rect_size.y}
	
	connect("resized", self, "_on_screen_resize")
	
		
	if test_mode: test()
	
	
var _list_errors = []
func reload():
	
	#empty the text field
	_RichTextLabel.bbcode_text = _copyright
	
	for obj_errors in _list_errors:
		#printt("obj_errors", obj_errors)
		out(obj_errors)


func _on_screen_resize():
	var local_debug: bool = false
	if local_debug and debug:
		print("->\tdebug_dock.gd")
		printt("_on_screen_resize")

	#printt("rect_size", rect_size)
	#printt("rect_min_size", rect_min_size)
	
	_window_resize(rect_size)

	reload()
	

func txt_size(txt: String) -> Vector2: 
	# found /t bug, this dont count \t or \n ...
	txt = txt.replace("\t", _tab_spaces)
	return RichTextLabel.new().get_font("normal_font").get_string_size(txt)
	

func get_dashs(txt: String, dash:String = "-", error_val: float = 0.5)-> String:
	
	var restx = _RichTextLabel.rect_size.x - txt_size(txt).x
	
	var rest_center = restx/2 
	var error_range = txt_size(dash).x * error_val
	var num_dashs = rest_center/txt_size(dash).x - error_range
	var dashs = kzStr.new(dash).duplicate(num_dashs)
	return dashs


var is_new_log: bool = false
func out(errors_obj: Dictionary):
	
	var local_debug = false
	if local_debug and  debug:
		print("->\tdebug_dock.gd")
		print("out()")
		print(_RichTextLabel)
	
	if not _RichTextLabel:
		disconnect("resized", self, "_on_screen_resize")
		_enter_tree()
		#_on_refresh_pressed()
		#return false
		
	#load data
	var array_errors: Array = errors_obj["array_errors"]
	var call_line: int  = errors_obj["call_line"]
	var script_name: String  = errors_obj["script_name"]
	var script_src: String  = errors_obj["script_src"]
	
	#initialize data
	_txt_max_width = rect_size.x 
		
	# all erros in one line
	var line_error: String = ""
	for error in array_errors:
		line_error += str(error) + "\t"
	line_error = line_error.left(line_error.length() - "\t".length()) # remove last tab \t
	var text_width = txt_size(line_error).x

	_expected_script_infos = "-> \t ({0}:{1})".format([script_name, call_line])
	var rest_width = txt_size(_expected_script_infos).x + _error_width_range
	
	var expected_width: float = text_width + rest_width
	
	var _width_to_remove = txt_size("----").x #txt_size("------").x
	
	#printt(rect_size.x )
	#printt(_width_to_remove)
	#printt(txt_size("-").x )

	var border_width = (rect_size.x - _width_to_remove) / txt_size("-").x  
	
	var output: String = ""
	
	
	
	#var reserved_width = rest_width + txt_size(" ").x + txt_size("\t").x
	var reserved_width = rest_width  + _width_to_remove + _scroll_bar_width
	#reserved_width += _border.x 
	var script_infos: String = "[color=#"+ _src_hexa_color +"]([url={0}]{1}[/url]:{2})[/color]"

	var link = script_src + ":" + str(call_line)
	script_infos = script_infos.format([link, script_name, call_line])
	
	if not errors_obj in _list_errors:
		# save local data for resize
		_list_errors.append(errors_obj)
	
	var script_example = "({0}:{1})".format([script_name, call_line])
	
	var dashs = get_dashs(script_example)
	if not options_obj.use_separator:
		dashs = ""
		
	if is_new_log: # after each new scene open
		
		# idea 1 separator
		#var print_separator = get_dashs("")
		#_RichTextLabel.bbcode_text += "[center][color=red]{0}[/color][/center]".format([print_separator + print_separator])
		
		# idea 2 clear old data
		_RichTextLabel.bbcode_text = ""
		
	#text with colors
	_RichTextLabel.bbcode_text +=  "[center]{0}{1}{2}\n[/center]".format([dashs, script_infos, dashs])
	
	for error in array_errors:
		var add_on = _tab_spaces if str(error) != str(array_errors[0]) else ""

		var exp_obj = KzStr.new(error)
		#printt("error", error, error is Dictionary)
		if error is Dictionary:
			#print(exp_obj.obj_to_str(error))
			
			_RichTextLabel.bbcode_text += add_on +  str(exp_obj.obj_to_str(error))
		elif error is Array:
			#print(exp_obj.array_to_str(error))
			_RichTextLabel.bbcode_text += add_on + str(exp_obj.array_to_str(error))
		else:
			_RichTextLabel.bbcode_text += add_on + str(error)


func test():
	
	var errors_obj = {
		"array_errors": ["array_errors"], 
		"call_line": 15,
		"script_name": "script_name",
		"script_src": "script_src",
	}

	out(errors_obj)


func _on_clear_pressed():
	
	#printt(_copyright, _RichTextLabel.rect_size)
	_RichTextLabel.bbcode_text = _copyright
	_list_errors = []
	

func _on_RichTextLabel_meta_clicked(meta_url):
	
	var list_data = str(meta_url).split(':')

	var line = list_data[list_data.size() - 1]
	var i = 0;
	var url = ""
	for txt in list_data:
		if i != list_data.size() - 1:
			url += txt + ":"
		i+=1
	url = url.left(url.length() - 1) # remove ':'
	
	var obj = {"url": url, "line": line}
	json_goto.array_append(obj)


var resize_disconnected = false
func _apply_options(obj):
	
	options_menu_was_created = false
	#disconnect("resized", self, "_on_screen_resize")
	
	#print("_apply_options")
	
	# updating options_obj
	options_obj = obj
	
	var min_x = int(options_obj.min_size.x)
	var min_y = int(options_obj.min_size.y)
	#var min_win_size = Vector2(min_x, min_y)
	
	rect_min_size.x = min_x
	#rect_min_size.y = min_y
	if rect_min_size.x > min_x:
		rect_size.x = min_x
		#rect_size.y = min_y
	
	_top_bar_col.color = Color(options_obj.top_bar_color)
	_src_hexa_color = Color(options_obj.src_color).to_html()
	
	reload()
	
	options_obj["dock_min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
	json_default.obj_append(options_obj)
	
	#print("end _apply_options")


var options_menu_was_created: bool = false
func _on_options_menu_close():
	#print("sdfsdf")
	options_menu_was_created = false
	

func _on_options_pressed():
	
	#print(options_menu_was_created)
	if not options_menu_was_created:
		
		options_menu = options_menu_scene.instance()
		options_menu.rect_position = rect_position
		
		options_menu.connect("_on_apply_btn_pressed", self, "_apply_options")
		add_child(options_menu)
		options_menu.min_size = Vector2(275, 200)
		options_obj["min_size"] = options_obj.dock_min_size
		options_menu.init(options_obj)
		options_menu.dock_settings()
		options_menu.connect("tree_exiting", self, "_on_options_menu_close")
		options_menu.get_close_button().connect("pressed", self, "_on_options_menu_close")
		options_menu_was_created = true
		

func _on_sponsor_pressed():
	OS.shell_open("https://kztcp.github.io/me/me.html")


func _on_dock_pressed():
	
	json_dock.write({"type": "win"})
	
	json_default.obj_append({"dock": {"type": "win"}})
	#printt(json_dock.read())
	
	kz_signal.write({})# clear json file
	
	# save thing after docking
	for obj_errors in _list_errors:
		kz_signal.array_append(obj_errors)


func _on_quit_pressed():
	queue_free()


func _on_refresh_pressed():
	
	var obj = {"plugin": {"refresh": true}}
	if not json_default:
		json_default = Json.new("res://addons/kz_debugger/json/default.json")
	
	json_default.obj_append(obj)

	
func clear():
	_RichTextLabel.bbcode_text = _copyright
