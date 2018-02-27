extends Spatial

func _ready():
	pass

func set_player_name(new_name):
	get_node("BODY/Viewport/Nametag/Label").set_text(new_name)
	update()

func update():
	var tex = get_node("BODY/Viewport").get_texture()
	var mesh = get_node("BODY/MeshInstance")
	var material = SpatialMaterial.new()
	material.flags_unshaded=true
	material.flags_transparent=true
	mesh.set_surface_material(0, material)
	mesh.get_surface_material(0).albedo_texture = tex
