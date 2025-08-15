tool
extends WindowDialog

		
var window_settings_scene = preload(
	"res://addons/kz_debugger/scenes/settings/WindowSettings/WindowSettings.tscn"
)

const ui_script = preload("res://addons/kz_debugger/scenes/UI/UI.gd")
var ui: ConsoleUIKZ


var _top_bar_h: float  = 25
var _border = Vector2(4, 4)
var os_size = OS.window_size


# different
var _is_ready: bool = false
func _window_resize(window_size: Vector2):
	
	if not _is_ready: return
	if ConfigKZD.DEBUG: printt("->\t window.dg _window_resize")
	
	if rect_size < ConfigKZD.WINDOW_SIZE: return # lock resize to min value
	
	ui._txt_max_width = window_size.x
	
	var top_bar_size = Vector2(ui._txt_max_width, _top_bar_h) - _border * 2
	
	ui._top_bar_col.rect_size = top_bar_size
	
	ui._HBoxContainer.rect_size = top_bar_size
	
	#_clear_btn.rect_size.y = _top_bar_h - _border.y * 2
	ui._top_bar_col.rect_size.y = ui._clear_btn.rect_size.y
	
	var text_y = window_size.y - _top_bar_h 
	var text_area_size = Vector2(ui._txt_max_width, text_y) - _border * 2
	
	ui._text_bg_color.rect_size = text_area_size
	ui._text_bg_color.rect_position.y = _top_bar_h + _border.x
	
	ui._RichTextLabel.rect_size = text_area_size
	ui._RichTextLabel.rect_position.y = _top_bar_h + _border.x


func _update_sizes():
	
	ui.options_obj["min_size"] = {"x": rect_min_size.x, "y": rect_min_size.y}
	ui.options_obj["position"] = {"x": rect_position.x, "y": rect_position.y}
	ui.options_obj["size"] = {"x": rect_size.x, "y": rect_size.y}
	


var _width_to_remove
func _enter_tree():
	
	if ConfigKZD.DEBUG: printt("->\tplug_debug_win.dg _enter_tree")
		
	
	show()
	resizable = true

	ui = ui_script.new(
		$RichTextLabel,
		$text_bg_color,
		$topBarCol,
		$HBoxContainer,
		$HBoxContainer/clear,
		self
	)
	
	ui.json_init()
	
	var window_settings = ui.json_window_settings.read()
	
	if ConfigKZD.DEBUG: printt("window_settings", window_settings)
	
	
	if window_settings:
		
		ui.options_obj = window_settings
		
	else:
		
		# initialize data
		ui.options_obj = WindowSettingsKZD.get_default_settings()
		
		
	rect_size =  VecTwo.to_vect(ui.options_obj.size)
	rect_min_size =  VecTwo.to_vect(ui.options_obj.min_size)
	rect_position =  VecTwo.to_vect(ui.options_obj.position)

	ui.structure()
	
	_width_to_remove = ui.labelText.size("------").x 
	
	_is_ready = true
	_window_resize(rect_size)
	
	#update resolution
	_update_sizes()
	
	connect("resized", self, "_on_screen_resize")
	



func _on_screen_resize():
	
	if not _is_ready: return
	
	if ConfigKZD.DEBUG:  printt("->\tplug_debug_win.dg _on_screen_resize")
	
	_window_resize(rect_size)
	
	ui.reload()
	
	if not ui.settings_are_open(): return 
		
	_update_sizes()
	
	ui.settings.init(ui.options_obj)# initialize potions



func _on_RichTextLabel_meta_clicked(meta_url):
	ui.navigate_to_script(meta_url)


func _save_settings():
	
	_update_sizes()
	#save new settings
	ui.json_window_settings.obj_append(ui.options_obj)
	

func _apply_options(obj):
	
	ui._apply_options(obj)
	
	rect_min_size = Vector2(
		int(ui.options_obj.min_size.x), 
		int(ui.options_obj.min_size.y)
	)
	
	
	var win_size = Vector2(
		int(ui.options_obj.size.x),
		int(ui.options_obj.size.y)
	)
	
	rect_size = win_size
	
	_window_resize(win_size)
	
	if ui.options_obj.use_snap: snap_to(ui.options_obj.snap)
	
	ui.reload()
	
	_save_settings()


# different
func _on_settings_pressed():
	
	ui.set_settings(
		window_settings_scene.instance()
	)




# s nap logic
func snap_to(direction):
	
	if ConfigKZD.DEBUG: print("window.gd snap_to")
		
	var _snap_percentage = int(ui.options_obj.snap_percentage)
	
	var _snap_vec = VecTwo.to_vect(ui.options_obj.snap_vector)
	
	if direction == SnapKZD.BOTTOM:
		
		rect_size =  Vector2(
			(os_size.x * _snap_percentage) / 100,
			_snap_vec.y
		)
		
		_window_resize(rect_size)
		
		rect_position = Vector2(
			(os_size.x - rect_size.x)/2,
			os_size.y - rect_size.y
		)
		
		
	elif  direction == SnapKZD.CENTER:
		
		rect_min_size = _snap_vec
		rect_size = _snap_vec
		
		_window_resize(rect_size)
		
		rect_position = (os_size - rect_size)/2
		
	else:
		
		# right or left. no top
		var x_axis = 0 # left case by fdefault
		if  direction == SnapKZD.RIGHT:
			x_axis = (os_size.x - rect_size.x)
		
		rect_size = Vector2(
			_snap_vec.x, 
			(os_size.y * _snap_percentage)/100
		)
		
		_window_resize(rect_size)
		
		rect_position = Vector2( 
			x_axis, 
			(os_size.y - rect_size.y)/2 
		)
		


func _on_save_pos_pressed():
	
	_save_settings()


func _on_resnap_pressed():
	
	if ui.options_obj.use_snap:
		snap_to(ui.options_obj.snap)
	else:
		rect_min_size = ui.options_obj["min_size"]
		rect_position = ui.options_obj["position"]
		rect_size     = ui.options_obj["size"]


func _on_sponsor_pressed():
	ui._on_sponsor_pressed()


func _on_dock_pressed():
	ui.set_dock(DockTypeKZD.CONTROL)


func _on_quit_pressed():
	ui._on_quit_pressed()


func _on_refresh_pressed():
	ui._on_refresh_pressed()


func _on_clear_pressed():
	ui.clear()
	
	
