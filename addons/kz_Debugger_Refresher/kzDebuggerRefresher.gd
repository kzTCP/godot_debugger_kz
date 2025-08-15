tool
extends EditorPlugin


var Json = load("res://addons/kz_debugger/scripts/json.gd")

const plugin_name = "kz_debugger"
var json_default: kzJson
var timer: Timer	

func _enter_tree():
	
	json_default = Json.new("res://addons/kz_debugger/json/default.json")
	
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.25
	timer.connect("timeout", self, "_signal_refrech_time_out")
	add_child(timer)


func _exit_tree():
	pass



func _refrech_plugin():
	 
	if not json_default: return 
	
	var obj_default = json_default.read()
	
	#print(obj_default)
	
	if not obj_default: return 
	if not "plugin" in obj_default: return 
	
	var plugin_obj = obj_default["plugin"]
	
	if not "refresh" in plugin_obj: return 
	
	var refresh_plugin = plugin_obj["refresh"]
	
	if not refresh_plugin: return
	
	var enabled = get_editor_interface().is_plugin_enabled(plugin_name)
	if enabled: # can only disable an active plugin
		get_editor_interface().set_plugin_enabled(plugin_name, false)
	get_editor_interface().set_plugin_enabled(plugin_name, true)
	json_default.obj_append({"plugin": {"refresh": false}})
	

func _signal_refrech_time_out():
	
	timer.stop()

	_refrech_plugin()
	
	timer.start()
	
