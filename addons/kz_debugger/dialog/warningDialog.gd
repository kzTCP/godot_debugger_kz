tool
class_name kz_msgBox extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var title: String = "warning"

var _rect_size = Vector2(512, 200)

var type = {
	"yes_no": false,
	"yes_no_cancel": true, 
	"ok_cancel": false,
	"ok": false,
}

var _richTextLabel: RichTextLabel
var _ok_btn: Button
var _yes_btn: Button
var _no_btn: Button
var _cancel_btn: Button
var _btns_container: HBoxContainer
var separator_y: int = 20


func txt_size(string):
	return _richTextLabel.get_font("normal_font").get_string_size(string)
	
	
func get_num_lines(msg) -> int:
	
	var max_width = _rect_size.x
	var num_y = txt_size(msg).x/ max_width 
	
	var out = num_y if int(num_y) == num_y else int(num_y) + 1
	return out


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	
	rect_size = _rect_size

	_richTextLabel = $txt
	_btns_container = $HBoxContainer
	_ok_btn = $HBoxContainer/ok
	_yes_btn = $HBoxContainer/yes
	_no_btn = $HBoxContainer/no
	_cancel_btn = $HBoxContainer/cancel
	
	window_title = title.to_upper()
	
	_richTextLabel.bbcode_enabled = true
	_richTextLabel.rect_size.x = rect_size.x
		
	rect_position = (OS.window_size - rect_size)/2


func set_type(value: String):
	
	if not value.find("ok") >= 0:
		_ok_btn.hide()
	if not value.find("yes") >= 0:
		_yes_btn.hide()
	if not value.find("no") >= 0:
		_no_btn.hide()
	if not value.find("cancel") >= 0:
		_cancel_btn.hide()


func set_text(text:String):
	
	var num_lines = get_num_lines(text)
	var line_hieght = txt_size("hello").y
	var txt_height = line_hieght * num_lines
	var position_needed = txt_height -  line_hieght
	
	var needed_height = txt_height + separator_y + _btns_container.rect_size.y
	#printt(num_lines, line_hieght, position_needed, needed_height)
	
	var center = rect_size/2
	
	var y_start =  center.y - needed_height/2
	
	_richTextLabel.bbcode_text = "[center]"+ text + "[/center]"
	_richTextLabel.rect_size.y = txt_height
	_richTextLabel.fit_content_height = true
	
	_richTextLabel.rect_position.y = y_start 
	_btns_container.rect_position.y = y_start + separator_y + txt_height# after text 
	
	_richTextLabel.rect_position.x = 0
	_btns_container.rect_position.x = center.x - _btns_container.rect_size.x/2
	

signal yes
func _on_yes_pressed():
	emit_signal("yes", self)
	hide()


signal no
func _on_no_pressed():
	emit_signal("no", self)
	hide()


signal cancel
func _on_cancel_pressed():
	emit_signal("cancel", self)
	hide()


signal ok
func _on_ok_pressed():
	emit_signal("ok", self)
	hide()


