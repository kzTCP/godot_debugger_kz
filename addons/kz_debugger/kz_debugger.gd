tool
extends EditorPlugin



var Json = preload("res://addons/kz_debugger/scripts/json.gd")

var _debug_dock_scene = preload(
	"res://addons/kz_debugger/scenes/dock/debug_dock.tscn"
)
var _plug_debug_win_scene = preload(
	"res://addons/kz_debugger/scenes/plug_debug_win/plug_debug_win.tscn"
)

var _debugger_script_path = "res://addons/kz_debugger/scripts/Debugger.gd"
var _json_path = "res://addons/kz_debugger/json/"


var current_script: Script 

# A class member to hold the dock during the plugin life cycle.
var dock

const AUTOLOAD_NAME = "console"# auto load scene as Debugger

var interface: EditorInterface

var json: kzJson
var kz_signal: kzJson
var json_goto: kzJson
var json_dock: kzJson
var json_default: kzJson
var timer: Timer


var stop_signal: bool = false
var debug: bool = false


func load_dock():
	var scene_isntance
	if json_default:
		var obj_default = json_default.read()
		#print(obj_default)
		if obj_default and "dock" in obj_default:
			var dock_obj = obj_default["dock"]
			if "type" in dock_obj:
				var dock_type = dock_obj["type"]
				if dock_type == "control":
					scene_isntance = _debug_dock_scene.instance()
				elif  dock_type == "win":
					scene_isntance = _plug_debug_win_scene.instance()
					
	if not scene_isntance: 
		scene_isntance = _plug_debug_win_scene.instance()
		
	return scene_isntance


func _out_of_dock():
	#print("_out_of_dock")
	dock = null
	

func _enter_tree():
	
	interface = get_editor_interface()
	
	kz_signal = Json.new(_json_path + "signal.json")
	json_goto = Json.new(_json_path + "goto.json")
	json_dock = Json.new(_json_path + "dock.json")
	json_default = Json.new(_json_path + "default.json")
	
	json_dock.write({})
	kz_signal.write({})

	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.25
	timer.connect("timeout", self, "_signal_refrech_time_out")
	if not stop_signal: add_child(timer)

	# The autoload can be a scene or script file.
	add_autoload_singleton(AUTOLOAD_NAME, _debugger_script_path)
	
	dock = load_dock()
	
	if debug: printt("loaded dock", dock)
	
	dock.connect("tree_exited", self, "_out_of_dock")
	#set_dock_title(dock, "kzdebugger")
	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.


var scene_is_playing = false
var once: bool = true
func _get_txt_to_print_from_scene():
	if kz_signal:
		var data = kz_signal.read()
		var array = data if data is Array else [data]
		if not data:
			# no data to work with
			return
		
		dock.is_new_log = not scene_is_playing
		for obj in array:
			dock.out(obj)
			scene_is_playing = true
			dock.is_new_log = not scene_is_playing
			kz_signal.array_remove(obj)
			

func _get_script_infos_from_scene():
	
	if json_goto:
		var data = json_goto.read()
		if not data:
			# no data to work with
			return
			
		var array_goto =  data if data is Array else [data]

		for obj_goto in array_goto:
			var url = obj_goto["url"]
			var line = obj_goto["line"]
			_goto_script_line(url, int(line))
			json_goto.array_remove(obj_goto)


func _get_dock_type():
	
	if json_dock:
		var dock_obj = json_dock.read()
		if dock_obj:
			
			if debug: 
				print("res://addons/h/h.gd")
				printt("dock_obj", dock_obj)
			
			if is_instance_valid(dock):
				# Remove the dock.
				remove_control_from_docks(dock)
				#dock.free()
				
			var type = str(dock_obj["type"]).to_lower()

			#printt(type, dock)
			
			if type == "win":
				dock = _plug_debug_win_scene.instance()
				# Add the loaded scene to the docks.
				
			elif type == "control":
				dock = _debug_dock_scene.instance()
				# Add the loaded scene to the docks.
				
			# Add the loaded scene to the docks.
			add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)
			
			json_dock.write({})# initialize to avoid entering here again
	

var scene_was_closed = true
func _signal_refrech_time_out():
	
	timer.stop()
	if dock:
		
		_get_dock_type()
		_get_script_infos_from_scene()
		
		if interface.is_playing_scene():
			_get_txt_to_print_from_scene()
			# clear old text after running a new scene
			if scene_was_closed:
				dock.clear()
			scene_was_closed = false
		else:
			scene_was_closed = true
	
	timer.start()
	
	
func _goto_script_line(error_path: String, line_error: int):
	
	#printt("_on_link_pressed")
	#printt(error_path, line_error)
	
	var script_editor = interface.get_script_editor()

	#script_editor.goto_line(26)
	#printt("scripts", scripts)
	
	if str(error_path).find("res://") >= 0:
		
		# switch to a script in godot at line 392 without select
		interface.edit_script(load(error_path) as Script) 
		# goto line 392 and auto select it
		script_editor.goto_line(line_error-1)
		


func _exit_tree():
	# Clean-up of the plugin goes here.
	if is_instance_valid(dock):
		# Remove the dock.
		remove_control_from_docks(dock)
		# Erase the control from the memory.
		if dock != null:
			dock.free()
	else:
		pass
		#print("_exit_tree no dock")
		
	remove_autoload_singleton(AUTOLOAD_NAME)
	
	
