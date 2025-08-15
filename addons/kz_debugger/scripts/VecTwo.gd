class_name VecTwo extends Object


static func to_vect(obj: Dictionary):
	
	if "x" in obj and "y" in obj:
		return Vector2(obj.x, obj.y) 
		
	assert("Invaled objet: {0}".format(obj))


static func to_obj(vect: Vector2) -> Dictionary:
	
	return {"x": vect.x, "y": vect.y}
		
