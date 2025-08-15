tool
class_name ConsoleUIKZ extends Control


var dock_type_script = load("res://addons/kz_debugger/scripts/DockType.gd")
var json_script  = preload("res://addons/kz_debugger/scripts/json.gd")
var kzstr_script = preload("res://addons/kz_debugger/scripts/KzStr.gd")

const JSON_PATH = "res://addons/kz_debugger/json/"


var _txt_max_width: float
var _copyright: String
var _list_errors: Array = []
var _src_hexa_color: String



var _debugger: Control
var _RichTextLabel: RichTextLabel
var _text_bg_color: ColorRect
var _top_bar_col: ColorRect
var _HBoxContainer: HBoxContainer
var _clear_btn: TextureButton


var json_goto: kzJson
var json_default: kzJson
var json_dock_settings: kzJson
var json_window_settings: kzJson
var json_dock: kzJson
var json_signal: kzJson

var settings: DockSettingsKZD
var labelText: TextRTLKZ


var options_obj: Dictionary = {}
	

func _init(
	richTextLabel: RichTextLabel,
	text_bg_color: ColorRect,
	top_bar_col: ColorRect,
	hBoxContainer: HBoxContainer,
	clear_btn: TextureButton,
	debugger: Control
):
	
	_RichTextLabel = richTextLabel
	_text_bg_color = text_bg_color
	_top_bar_col = top_bar_col
	_HBoxContainer = hBoxContainer
	_clear_btn = clear_btn
	_debugger = debugger


func structure():

	
	_top_bar_col.color = Color(options_obj.top_bar_color)
	_src_hexa_color = Color(options_obj.src_color).to_html()
	_RichTextLabel.bbcode_enabled = true
	_RichTextLabel.selection_enabled = true
	_RichTextLabel.scroll_following = true
	
	_copyright = "[center][color=gray]{0}[/color][/center]\n".format(
		["---- kzCode_ Debugger ----"]
	)
	_RichTextLabel.bbcode_text = _copyright
		
	labelText = TextRTLKZ.new(_RichTextLabel)
	
	if ConfigKZD.DEBUG: print("structure")
	

func json_init():
	
	json_goto = kzJson.new(JSON_PATH + "goto.json")
	json_default = kzJson.new(JSON_PATH + "default.json")
	json_dock = kzJson.new(JSON_PATH+  "dock.json")
	json_signal = kzJson.new(JSON_PATH + "signal.json")
	json_dock_settings  = kzJson.new(JSON_PATH + "dock_settings.json")
	json_window_settings  = kzJson.new(JSON_PATH + "window_settings.json")
	

var is_new_log: bool = false # clear text after each test launch
func out(errors_obj: Dictionary):
	
	if ConfigKZD.DEBUG: print( "->\t ui.gg out()")
		
	
	if not _RichTextLabel:
		disconnect("resized", self, "_on_screen_resize")
		_enter_tree()
		#_on_refresh_pressed()
		#return false
		if ConfigKZD.DEBUG: print("not _RichTextLabel")
		
	#load data
	var array_errors: Array = errors_obj["array_errors"]
	var call_line: int  = errors_obj["call_line"]
	var script_name: String  = errors_obj["script_name"]
	var script_src: String  = errors_obj["script_src"]
	
	#initialize data
	_txt_max_width = rect_size.x 
	
	#reserved_width += _border.x 
	var script_infos: String = "[color=#"+ _src_hexa_color +"]"
	script_infos += "([url={0}]{1}[/url]:{2})[/color]"

	var link = script_src + ":" + str(call_line)
	script_infos = script_infos.format([link, script_name, call_line])
	
	if not errors_obj in _list_errors:
		# save local data for resize
		_list_errors.append(errors_obj)

	var script_example = "({0}:{1})".format([script_name, call_line])

	#print_debug(script_example)

	var dashs = labelText.get_dashs(script_example)
	#var dashs = get_dashs("")
	if not options_obj.use_separator:
		dashs = ""

	if is_new_log: # after each new scene open
		_RichTextLabel.bbcode_text = ""


	_RichTextLabel.bbcode_text +=  "[center]{0}{1}{2}\n[/center]".format([
		dashs, script_infos, dashs
	])


	for index in array_errors.size():

		# what an error
		var add_on = ""if index == 0 else labelText._tab_spaces
		
		var error = array_errors[index]

		#printt("error", error, error is Dictionary)
		if error is Dictionary:
			_RichTextLabel.bbcode_text += add_on +  str(
				KzStr.new(error).obj_to_str(error)
			)
		elif error is Array:
			_RichTextLabel.bbcode_text += add_on + str(
				KzStr.new(error).array_to_str(error)
			)
		else:
			_RichTextLabel.bbcode_text += add_on + str(error)

		_RichTextLabel.bbcode_text += '[color=white]'# support multi colors


func reload():
	
	#empty the text field
	_RichTextLabel.bbcode_text = _copyright
	
	for obj_errors in _list_errors:
		#printt("obj_errors", obj_errors)
		out(obj_errors)


func navigate_to_script(url):
	
	var list_data = str(url).split(':')

	var line = list_data[list_data.size() - 1]
	var i = 0;
	var _url = ""
	for txt in list_data:
		if i != list_data.size() - 1:
			_url += txt + ":"
		i+=1
	_url = _url.left(_url.length() - 1) # remove ':'
	
	json_goto.array_append(
		{"url": _url, "line": line}
	)



func _apply_options(obj):
	
	settings = null
	options_obj = obj
	
	_top_bar_col.color = Color( options_obj.top_bar_color )
	_src_hexa_color = Color( options_obj.src_color ).to_html()
	

func settings_are_open(): return settings != null


func _on_options_menu_close(): settings = null


func set_settings(instance: DockSettingsKZD):
	
	if settings_are_open(): return 
	
	settings = instance
	
	settings.rect_position = rect_position
	settings.connect(
		"_on_apply_btn_pressed", _debugger, "_apply_options"
	)
	settings.connect(
		"tree_exiting", self, "_on_options_menu_close"
	)
	settings.get_close_button().connect(
		"pressed", self, "_on_options_menu_close"
	)
	
	_debugger.add_child(settings)
	
	
	# save current window size
	options_obj.size = _debugger.rect_size

	settings.init(options_obj)

	

func _on_sponsor_pressed():
	OS.shell_open("https://kztcp.github.io/me/me.html")


func set_dock(dock_type: String):
	
	if settings_are_open():
		settings.queue_free()
		settings = null
	
	json_dock.write({"type": dock_type})
	json_default.obj_append({"dock_type": dock_type})

	json_signal.write([]) # clear json file
	
	# save thing after docking
	for obj_errors in _list_errors:
		json_signal.array_append(obj_errors)
		


func _on_quit_pressed():
	_debugger.queue_free()


func _on_refresh_pressed():
	
	var obj = {"plugin": {"refresh": true}}
	if not json_default:
		json_default = json_script.new(JSON_PATH + "default.json")
	
	json_default.obj_append(obj)
	_debugger.queue_free()
	
	
func clear():
	_RichTextLabel.bbcode_text = _copyright
	_list_errors = []

