class_name TextRTLKZ extends Object


var _tab_spaces: String
var _richTextLabel: RichTextLabel



func _init(richTextLabel: RichTextLabel):
	
	_richTextLabel = richTextLabel
	_set_tab_spaces()


func _set_tab_spaces():
	#generate tab spaces
	for i in range(_richTextLabel.tab_size):
		_tab_spaces += ' '



func size(txt: String) -> Vector2: 
	# found /t bug, this dont count \t or \n ...
	txt = txt.replace("\t", _tab_spaces)
	return RichTextLabel.new().get_font("normal_font").get_string_size(txt)
	
	
func get_dashs(txt_between: String, dash:String = "-", error_val: float = 0.5)-> String:
	
	var restx = int(_richTextLabel.rect_size.x -  size(txt_between).x)
	
	var rest_center = restx/2 
	var error_range =  size(dash).x * error_val
	var num_dashs = rest_center/ size(dash).x - error_range
	var dashs = KzStr.new(dash).duplicate(num_dashs)
	return dashs
