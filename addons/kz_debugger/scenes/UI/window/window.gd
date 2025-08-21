tool
extends WindowDialog

		
var window_settings_scene = preload(
	"res://addons/kz_debugger/scenes/settings/WindowSettings/WindowSettings.tscn"
)

var ui_script = load("res://addons/kz_debugger/scenes/UI/UI.gd")
var ui: UIKZD


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
	
	ui.settings_data.min_size	= VecTwo.to_obj(rect_min_size)
	ui.settings_data.size 		= VecTwo.to_obj(rect_size)
	ui.settings_data.position	= VecTwo.to_obj(rect_position)
	

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
	
	ui.settings_data = WindowSettingsDataKZD.new()
	
	var window_settings = ui.settings_data.read()
	
	if ConfigKZD.DEBUG: printt("window_settings", window_settings)
	
	if window_settings:
		
		ui.settings_data = window_settings
		
	else:
		
		# initialize data
		ui.settings_data = WindowSettingsDataKZD.new()
		ui.settings_data.save()
		
	rect_min_size =  VecTwo.to_vect(ui.settings_data.min_size)
	rect_size =  VecTwo.to_vect(ui.settings_data.size)
	rect_position =  VecTwo.to_vect(ui.settings_data.position)

	ui.structure()
	
	_is_ready = true
	
	_window_resize(rect_size)
	
	connect("resized", self, "_on_screen_resize")
	


func _on_screen_resize():
	
	if not _is_ready: return
	
	if ConfigKZD.DEBUG:  printt("->\tplug_debug_win.dg _on_screen_resize")
	
	_window_resize(rect_size)
	
	ui.reload()
	
	if not ui.settings_are_open(): return 
		
	_update_sizes()
	
	ui.settings.init(ui.settings_data) # initialize potions



func _on_RichTextLabel_meta_clicked(meta_url):
	ui.navigate_to_script(meta_url)


func _save_settings():
	
	_update_sizes()
	
	#save new settings
	ui.settings_data.save()
	
	

func _on_save_settings(obj):
	
	ui._on_save_settings(obj)
	
	rect_min_size = VecTwo.to_vect(ui.settings_data.min_size)
	
	var win_size = VecTwo.to_vect(ui.settings_data.size)
	
	rect_size = win_size
	
	_window_resize(win_size)
	
	if ui.settings_data.use_snap: 
		snap_to(ui.settings_data.snap)
	
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
		
	var _snap_percentage = int(ui.settings_data.snap_percentage)
	
	var _snap_vec = VecTwo.to_vect(ui.settings_data.snap_vector)
	
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
	
	_update_sizes()
	
	#forgot to save
	ui.settings_data.save()
	

func _on_resnap_pressed():
	
	if ui.settings_data.use_snap:
		snap_to(ui.settings_data.snap)
	else:
		rect_min_size = VecTwo.to_vect(ui.settings_data.min_size)
		rect_position = VecTwo.to_vect(ui.settings_data.position)
		rect_size     = VecTwo.to_vect(ui.settings_data.size)


func _on_dock_pressed():
	
	ui.set_dock(DockTypeKZD.CONTROL)
	
	
func _on_sponsor_pressed():
	ui.sponsor()


func _on_quit_pressed():
	ui.quit()


func _on_refresh_pressed():
	ui.refresh()


func _on_clear_pressed():
	ui.clear()

	
