tool
extends Control


var dock_settings_scene = preload(
	"res://addons/kz_debugger/scenes/settings/DockSettings/DockSettings.tscn"
)

const ui_script = preload("res://addons/kz_debugger/scenes/UI/UI.gd")
var ui: UIKZD

var _top_bar_h: float  = 25


# different
var _is_ready: bool = false
func _window_resize(window_size: Vector2):
	
	if not _is_ready: return
	if ConfigKZD.DEBUG: print("->\t dock.gd _window_resize")
		
	ui._txt_max_width = window_size.x
	
	var top_bar_size = Vector2(ui._txt_max_width, _top_bar_h) 
	
	ui._top_bar_col.rect_size = top_bar_size
	ui._HBoxContainer.rect_size = top_bar_size
	
	ui._top_bar_col.rect_size.y = ui._clear_btn.rect_size.y
	
	var text_y = window_size.y - _top_bar_h 
	var text_area_size = Vector2(ui._txt_max_width, text_y) 
	
	ui._text_bg_color.rect_size = text_area_size
	ui._text_bg_color.rect_position.y = _top_bar_h 
	
	ui._RichTextLabel.rect_size = text_area_size
	ui._RichTextLabel.rect_position.y = _top_bar_h
	
	#printt("rect_size", rect_size)
	#printt("end _window_size()")
	


var default_pos: Vector2
func _enter_tree():

	if ConfigKZD.DEBUG: printt("->\tdebug_dock.gd _enter_tree")
	
	ui = ui_script.new(
		$RichTextLabel,
		$text_bg_color,
		$topBarCol,
		$HBoxContainer,
		$HBoxContainer/clear,
		self
	)

	
	ui.json_init()
	
	ui.settings_data = DockSettignsDataKZD.new()
	
	var dock_settings = ui.settings_data.read()
	
	if dock_settings:
		ui.settings_data = dock_settings # overwrite 
		
	else:
		# initialize data
		ui.settings_data = DockSettignsDataKZD.new()
		ui.settings_data.save()
		
	rect_min_size = VecTwo.to_vect(ui.settings_data.min_size)
	rect_size     = VecTwo.to_vect(ui.settings_data.size)

	ui.structure()
	
	_is_ready = true
	_window_resize(rect_size)
	
	# update min size
	ui.settings_data.min_size = {"x": rect_min_size.x, "y": rect_min_size.y}
	
	connect("resized", self, "_on_screen_resize")
	
	


func _on_screen_resize():

	if not _is_ready: return 
	if ConfigKZD.DEBUG: print("->\tdebug_dock.gd _on_screen_resize")

	#printt("rect_size", rect_size)
	#printt("rect_min_size", rect_min_size)
	
	_window_resize(rect_size)
	
	ui.reload()
	


func _on_RichTextLabel_meta_clicked(meta_url):
	ui.navigate_to_script(meta_url)


func _on_save_settings(obj):
	
	ui._on_save_settings(obj)
	
	# size doesn't do a thing
	rect_min_size = VecTwo.to_vect(ui.settings_data.min_size)
	
	ui.reload()
	 
	ui.settings_data.save()
	
	#print("end _apply_options")

	
# different
func _on_settings_pressed():
	
	ui.set_settings( dock_settings_scene.instance() )
	


func _on_dock_pressed():
	ui.set_dock(DockTypeKZD.WINDOW)


func _on_sponsor_pressed():
	ui.sponsor()

func _on_quit_pressed():
	ui.quit()


func _on_refresh_pressed():
	ui.refresh()
	
func _on_clear_pressed():
	ui.clear()
	
# i don't think you wanna mess with this one ^_^
#func _exit_tree():
#	ui.quit()

