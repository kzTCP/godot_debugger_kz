tool
extends EditorPlugin


const Json = preload("res://addons/kz_debugger/scripts/json.gd")

const _dock_scene = preload(
	"res://addons/kz_debugger/scenes/UI/dock/dock.tscn"
)
const _window_scene = preload(
	"res://addons/kz_debugger/scenes/UI/window/window.tscn"
)

const _console_script_path = "res://addons/kz_debugger/scripts/Console.gd"
const _json_path = "res://addons/kz_debugger/json/"


var current_script: Script 

# A class member to hold the dock during the plugin life cycle.
var dock

const AUTOLOAD_NAME = "console"# auto load scene as Debugger

var interface: EditorInterface

var json: kzJson
var json_signal: kzJson
var json_goto: kzJson
var json_dock: kzJson
var json_default: kzJson
var timer: Timer


var stop_signal: bool = false
var debug: bool = false


func load_dock():
	
	var dock_scene
	
	if json_default:
		
		var obj_default = json_default.read()
		
		if obj_default and "dock_type" in obj_default:
			var dock_type = obj_default["dock_type"]
			if dock_type == DockTypeKZD.CONTROL:
				dock_scene = _dock_scene.instance()
			elif  dock_type == DockTypeKZD.WINDOW:
				dock_scene = _window_scene.instance()
				
	if not dock_scene:
		# initialize
		dock_scene = _window_scene.instance()
		json_default.obj_append(
			{"dock_type": DockTypeKZD.CONTROL}
		)

	return dock_scene


func _out_of_dock():
	#print("_out_of_dock")
	dock = null
	

func _enter_tree():
	
	interface = get_editor_interface()
	
	json_signal = Json.new(_json_path + "signal.json")
	json_goto = Json.new(_json_path + "goto.json")
	json_dock = Json.new(_json_path + "dock.json")
	
	# auto created by the first dock
	json_default = Json.new(_json_path + "default.json")
	
	json_dock.write({})
	json_signal.write({})
	json_goto.write({})

	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.25 # refresh time in seconds
	timer.connect("timeout", self, "_signal_refrech_time_out")
	if not stop_signal: add_child(timer)

	# The autoload can be a scene or script file.
	add_autoload_singleton(AUTOLOAD_NAME, _console_script_path)
	
	dock = load_dock()
	
	if debug: printt("loaded dock", dock)
	
	dock.connect("tree_exited", self, "_out_of_dock")
	#set_dock_title(dock, "kzdebugger")
	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.


var scene_is_playing = false
func _get_txt_to_print_from_scene():
	
	if not json_signal: return 
	
	var array = json_signal.array_read()
#	print(array)
	if not array: return # no data to work with
	
	dock.ui.is_new_log = not scene_is_playing

	for obj in array:
#		print(obj)
		dock.ui.out(obj)
		scene_is_playing = true
		dock.ui.is_new_log = not scene_is_playing
		json_signal.array_remove(obj)



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
	

func _script_navigation_process():
	
	if not json_goto: return
		
	var array_goto = json_goto.array_read()
	
	if not array_goto: return # no data to work with
		
	for obj_goto in array_goto:
		var url = obj_goto["url"]
		var line = obj_goto["line"]
		_goto_script_line(url, int(line))
		json_goto.array_remove(obj_goto)


func _get_dock_type():
	
	if not json_dock: return 
	
	var dock_obj = json_dock.read()
	
	if not dock_obj: return
		
	if debug: print("kz_debugger.gd dock_obj", dock_obj)
	
	if is_instance_valid(dock):
		# Remove the dock.
		remove_control_from_docks(dock)
		#dock.free()
		
	var type = str(dock_obj["type"]).to_lower()

	#printt(type, dock)
	
	if type == DockTypeKZD.WINDOW:
		dock = _window_scene.instance()
		
	elif type == DockTypeKZD.CONTROL:
		dock = _dock_scene.instance()
		
	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)
	
	json_dock.write({}) # initialize to avoid entering here again
	

var scene_was_closed = true
func _signal_refrech_time_out():
	
	if not dock: return 
	
	timer.stop()
	
	_get_dock_type()
	
	_script_navigation_process()
	
	# must be disabled when exporting game

	if interface.is_playing_scene():
		
		_get_txt_to_print_from_scene()
		# clear old text after running a new scene
		if scene_was_closed: dock.ui.clear()
		scene_was_closed = false
		
	else:
		
		scene_was_closed = true
		
	timer.start()
	

func _exit_tree():
	
	# Clean-up of the plugin goes here.
	if is_instance_valid(dock):
		# Remove the dock.
		remove_control_from_docks(dock)
		# Erase the control from the memory.
		if dock != null: dock.free()
		
	remove_autoload_singleton(AUTOLOAD_NAME)
	
	
