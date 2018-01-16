extends MeshInstance

func _ready():
	if (get_parent().get_node("Viewport") != null):
		print("Setting a quad")
		var tex = get_parent().get_node("Viewport").get_texture()
		get_material_override().albedo_texture = tex
		
	pass
