tool
extends WindowDialog

# case of text problem:
# update reseved_width variable
#

var kzStr = preload("res://addons/kz_debugger/core/KzStr.gd")
 
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


var Json = preload("res://addons/kz_debugger/json.gd")
var json_goto: kzJson
var json_default: kzJson
var json_dock: kzJson
var kz_signal: kzJson
	

var options_menu_scene = preload("res://addons/kz_debugger/options/options.tscn")
var options_menu: kz_options

# example
var options_obj = {
	"use_separator": true,
	"size": {"x": 500, "y": 200},
	"min_size": {"x": 250, "y": 200},
	"snap": "center",
	"snap_percentage": _snap_percentage,
	"snap_x": _snap_vec.x,
	"snap_y": _snap_vec.y,
	"top_bar_color": "#999999",
	"src_color": "#faf223",
	"use_snap": false,
	"dock": {"type": "win"},
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
	
	_txt_max_width = window_size.x
	
	if debug: 
		printt("->\tplug_debug_win.dg")
		printt("_window_resize")
		printt("window_size", window_size)
	
	var top_bar_size = Vector2(_txt_max_width, _top_bar_h) - _border * 2
	
	_top_bar_col.rect_size = top_bar_size
	
	_HBoxContainer.rect_size = top_bar_size
	
	#_clear_btn.rect_size.y = _top_bar_h - _border.y * 2
	_top_bar_col.rect_size.y = _clear_btn.rect_size.y
	
	var text_y = window_size.y - _top_bar_h 
	var text_area_size = Vector2(_txt_max_width, text_y) - _border * 2
	
	_text_bg_color.rect_size = text_area_size
	_text_bg_color.rect_position.y = _top_bar_h + _border.x
	
	_RichTextLabel.rect_size = text_area_size
	_RichTextLabel.rect_position.y = _top_bar_h + _border.x


var _width_to_remove
func _enter_tree():
	
	if debug:
		printt("->\tplug_debug_win.dg")
		print("_enter_tree")
	
	json_goto = Json.new("res://addons/kz_debugger/json/goto.json")
	json_default = Json.new("res://addons/kz_debugger/json/default.json")
	json_dock = Json.new("res://addons/kz_debugger/json/dock.json")
	kz_signal = Json.new("res://addons/kz_debugger/json/signal.json")
	
	show()
	resizable = true
	#window_title = ""
	
	var obj = json_default.read()
	
	if debug: printt("obj", obj)
	
	#set default size
	if obj:
		
		if "size" in obj:
			options_obj = obj
			var x = int(options_obj.size.x)
			var y = int(options_obj.size.y)
			rect_size =  Vector2(x, y)
			
		if "min_size" in obj:
			options_obj = obj
			var x = int(options_obj.min_size.x)
			var y = int(options_obj.min_size.y)
			rect_min_size =  Vector2(x, y)
			
		if "position" in obj:
			var pos_x = int(options_obj.position.x)
			var pos_y = int(options_obj.position.y)
			rect_position =  Vector2(pos_x, pos_y)
		
	else:
		
		rect_min_size = Vector2(500, 200)
		rect_size = Vector2(500, 200)
		rect_position = (OS.window_size - rect_size)/2

	_structure()
	
	_width_to_remove = txt_size("------").x 
	
	_set_tab_spaces()
	
	_window_resize(rect_size)
	
	#update resolution
	options_obj["min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
	options_obj["position"] = {"x": rect_position.x, "y": rect_position.y}
	options_obj["size"] = {"x": rect_size.x, "y": rect_size.y}
	
	connect("resized", self, "_on_screen_resize")
	
	if test_mode: test()
	

func reload():
	
	#empty the text field
	_RichTextLabel.bbcode_text = _copyright
	
	for obj_errors in _list_errors:
		#printt("obj_errors", obj_errors)
		out(obj_errors)


var _list_errors = []
func _on_screen_resize():
	
	if debug: 
		printt("->\tplug_debug_win.dg")
		printt("_on_screen_resize")
	
	_window_resize(rect_size)
	
	reload()
	
	if options_menu_was_created:
		
		options_obj["min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
		options_obj["position"] = {"x": rect_position.x, "y": rect_position.y}
		options_obj["size"] = {"x": rect_size.x, "y": rect_size.y}
		options_menu.init(options_obj)# initialize potions


func txt_size(txt: String) -> Vector2: 
	# found /t bug, this dont count \t or \n ...
	txt = txt.replace("\t", _tab_spaces)
	return _RichTextLabel.get_font("normal_font").get_string_size(txt)
	

func word_to_lines(text:String, addOn:String, spliter:String="", gap:String="", reserved_space: float = 0):
	#gap = applied to all lines except first one 
	
	var rest_width = txt_size(_expected_script_infos).x
	
	var fst_line = ""
	var collector = ''
	var old_collector2 = ''
	var collector_2 = ''
	# why lines = [" "] because you have to reserve space for first line 
	# and lines = [" "] is better than lines = [0] which's confusing
	var lines = [" "] # reserve first index for first line

	var work_list
	if spliter:
		work_list = text.split(spliter)# text have target (list strings)
	else:
		work_list = text # text doensn't have target (list chars)
		
	#printt("work_list", work_list)
	
	for word in work_list:
		#printt("word", word)
		collector += str(word) + addOn
		
		if txt_size(collector).x + rest_width + reserved_space < _txt_max_width:
			if collector.ends_with(addOn):
				fst_line = collector.left(collector.length() - addOn.length())# remove last \t
			else:
				fst_line = collector
		else:
			collector_2 += str(word) + addOn # collect rest of text
			if txt_size(gap + collector_2).x + reserved_space  >= _txt_max_width:
				if old_collector2:
					lines.append(gap + old_collector2) # max was last line
					collector_2 = str(word) + addOn # collect current uncollected text
					old_collector2 = str(word) + addOn # this solved {issue_1}
			else:
				#collecting time
				if collector_2.ends_with(addOn):
					old_collector2 = collector_2.left(collector_2.length()- addOn.length())# remove last \t
				else:
					old_collector2 = collector_2
	#collect rest
	if old_collector2: 
		#printt("old_collector", old_collector)
		lines.append(gap + old_collector2) # max was last line
	else:
		# {issue_1} i don't think i need this code any more
		# case: work_list = [.get_string_size(txt).get_string_size(txt).get_string_size(txt).get_string_size(txt), kkkkkkkkkkkkkkkkkkkkkkkkkkkkkk, kkkkkkkkkkkkkkk, kkkkkk.get_string_size(txt).get_string_size(txt).get_string_size(txt).get_string_size(txt)]
		# end of for loop, collector_2 has data and old_collector is empty
		#collector_2	kkkkkk.get_string_size(txt).get_string_size(txt).get_string_size(txt).get_string_size(txt) 
		if collector_2:
			#printt("collector_2", collector_2)
			var sub_lines = word_to_lines(collector_2, "", spliter, gap, reserved_space)
			#printt("sub_lines_2", sub_lines)
			for sub_line in sub_lines:
				if fst_line:
					lines.append(gap + sub_line) # append lines
				else:
					fst_line = gap + sub_line # define first line
			collector_2 = ""
			old_collector2 = ""
			
	if fst_line:
		lines[0] = fst_line # overwrite first index
	return lines


func rearrange_errors_list(list_txt):
	
	var out_list = []
	for txt in list_txt:
		#printt("txt", txt)
		var lines
		
		var reseved_width = txt_size(_gap).x + txt_size("\t").x * 2 + _border.x  + _scroll_bar_width
		txt = str(txt)
		if txt.find(" ") >= 0:
			# case: dfgdfg dgh hdgh (sparated words)
			lines = word_to_lines(txt, " ", " ", "", reseved_width)
		else:
			# case: dfgdfgdghhdgh(link_words)
			lines = word_to_lines(txt, "", "", "", reseved_width)
		
		#printt("lines", lines)
		
		for line in lines:
			out_list.append(line)
	
	if not out_list.size(): print("not out_list.size()")
			
	return out_list


func _out_process(collector2, lines, old_collection2, error):
	
	if txt_size(_gap + collector2).x >= _txt_max_width:
		if old_collection2:
			#if debug: printt("insert old collecting")
			lines.append(_gap + old_collection2 + "\n") # save last text
			collector2 = str(error) + "\t" # collect uncollected text
			old_collection2 = str(error) + "\t" # collect uncollected text
	else:
		#collecting time
		if collector2.ends_with("\t"):
			old_collection2 = collector2.left(collector2.length()-1)# remove last \t
		else:
			old_collection2 = collector2 
		#if debug: printt("collecting...")
		
	return {
		"old_collection2": old_collection2, 
		"collector2": collector2, 
		"lines": lines
	}


func add_space(text: String, rest_width: float):
	
	while txt_size(text + " ").x + rest_width < _txt_max_width :
		text += " "
	return text


var is_new_log: bool = false # clear text after each test launch
func out(errors_obj: Dictionary):
	
	#load data
	var array_errors = errors_obj["array_errors"]
	var call_line: int  = errors_obj["call_line"]
	var script_name: String  = errors_obj["script_name"]
	var script_src: String  = errors_obj["script_src"]
	
	#initialize data
	_txt_max_width = rect_size.x 

	#reserved_width += _border.x 
	var script_infos: String = "[color=#"+ _src_hexa_color +"]([url={0}]{1}[/url]:{2})[/color]"

	var link = script_src + ":" + str(call_line)
	script_infos = script_infos.format([link, script_name, call_line])
	
	if not errors_obj in _list_errors:
		# save local data for resize
		_list_errors.append(errors_obj)
	
	var script_example = "({0}:{1})".format([script_name, call_line])
	
	var restx = _RichTextLabel.rect_size.x - txt_size(script_example).x
	
	var rest_center = restx/2 
	var error_range = txt_size("-").x *0.5
	var num_dashs = rest_center/txt_size("-").x - error_range
	var dashs = kzStr.new("-").duplicate(num_dashs)

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
			_RichTextLabel.bbcode_text += add_on + error


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


func _apply_options(obj):
	
	options_menu_was_created = false
	
	# updating options_obj
	options_obj = obj
	
	var min_x = int(options_obj.min_size.x)
	var min_y = int(options_obj.min_size.y)
	var min_win_size = Vector2(min_x, min_y)
	rect_min_size = min_win_size
	
	var x = int(options_obj.size.x)
	var y = int(options_obj.size.y)
	var win_size = Vector2(x, y)
	rect_size = win_size
	_window_resize(win_size)
	
	_top_bar_col.color = Color(options_obj.top_bar_color)
	_src_hexa_color = Color(options_obj.src_color).to_html()
	
	if options_obj.use_snap:
		snap_to(options_obj.snap)
	
	reload()
	
	options_obj["min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
	options_obj["position"] = {"x": rect_position.x, "y": rect_position.y}
	options_obj["size"] = {"x": rect_size.x, "y": rect_size.y}
	
	json_default.obj_append(options_obj)


var options_menu_was_created: bool = false
func _on_options_menu_close():
	options_menu_was_created = false
	

func _on_options_pressed():
	
	if not options_menu_was_created:
		
		options_menu = options_menu_scene.instance()
		options_menu.rect_position = rect_position
		
		options_menu.connect("_on_apply_btn_pressed", self, "_apply_options")
		add_child(options_menu)
		options_obj.size.x = rect_size.x
		options_obj.size.y = rect_size.y
		options_menu.min_size = Vector2(500, 200)
		options_menu.init(options_obj)
		options_menu.get_close_button().connect("pressed", self, "_on_options_menu_close")
		
		options_menu_was_created = true

func snap_to(direction):
	
	if debug:
		print("res://addons/kz_debugger/plug_debug_win.gd")
		print("snap_to")
		
	_snap_percentage = int(options_obj.snap_percentage)
	_snap_vec = Vector2(int(options_obj.snap_x), int(options_obj.snap_y))

	var win_center: Vector2
	var debugger_size: Vector2
	
	if direction == "bottom":
		
		var width = (os_size.x * _snap_percentage)/100
		debugger_size = Vector2(width, _snap_vec.y)
		
		#rect_min_size = debugger_size
		rect_size = debugger_size
		_window_resize(debugger_size)
		
		win_center = (os_size - rect_size)/2
		win_center.y  = os_size.y - rect_size.y
		rect_position = win_center
		
	elif  direction == "center":
		
		var x = int(options_obj.size.x)
		var y = int(options_obj.size.y)
		debugger_size = Vector2(x, y)
		
		#rect_min_size = debugger_size
		rect_size = debugger_size
		_window_resize(rect_size)
		
		win_center = (os_size - rect_size)/2
		rect_position = win_center
		
	elif  direction == "left":
		
		var _height = (os_size.y * _snap_percentage)/100
		debugger_size = Vector2(_snap_vec.x, _height)
		
		#rect_min_size = debugger_size
		rect_size = debugger_size
		_window_resize(debugger_size)
		
		var left_center: Vector2
		left_center.x = 0
		left_center.y  = (os_size.y - rect_size.y)/2
		rect_position = left_center
		
	elif  direction == "right":
		
		var _height = (os_size.y * _snap_percentage)/100
		debugger_size = Vector2(_snap_vec.x, _height)
		
		#rect_min_size = debugger_size
		rect_size = debugger_size
		
		_window_resize(debugger_size)
		
		var right_center: Vector2
		right_center.x = os_size.x - rect_size.x
		right_center.y  = (os_size.y - rect_size.y)/2
		rect_position = right_center


func _on_default_pos_pressed():
	
	options_obj["min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
	options_obj["position"] = {"x": rect_position.x, "y": rect_position.y}
	options_obj["size"] = {"x": rect_size.x, "y": rect_size.y}
	
	#save new settings
	json_default.obj_append(options_obj)


func _on_resnap_pressed():
	
	if options_obj.use_snap:
		snap_to(options_obj.snap)
	else:
		rect_min_size = Vector2(options_obj["min_size"].x, options_obj["min_size"].y)
		rect_position = Vector2(options_obj["position"].x, options_obj["position"].y)
		rect_size = Vector2(options_obj["size"].x, options_obj["size"].y)


func _on_sponsor_pressed():
	OS.shell_open("https://kztcp.github.io/me/me.html")


func _on_dock_pressed():
	
	json_dock.write({"type": "control"})
	json_default.obj_append({"dock": {"type": "control"}})
	
	kz_signal.write([])# clear json file
	
	#printt("_on_dock_pressed")
	#printt("obj", kz_signal.read())
	#printt("_list_errors", _list_errors)
	
	# save thing after docking
	for obj_errors in _list_errors:
		kz_signal.array_append(obj_errors)


func _on_quite_pressed():
	queue_free()


func _on_refresh_pressed():
	
	var obj = {"plugin": {"refresh": true}}
	if not json_default:
		json_default = Json.new("res://addons/kz_debugger/json/default.json")
	
	json_default.obj_append(obj)
