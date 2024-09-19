extends TextureButton

var volume_index := 4

func _ready() -> void:
	pressed.connect(changeVolume)
	
func changeVolume():
	volume_index -= 1
	volume_index = wrapi(volume_index, 0, 5)
	var new_texture = load("res://assets/buttons/volume_button_%s.png" % volume_index)
	texture_normal = new_texture
	texture_hover = new_texture
	texture_pressed = new_texture
	print(volume_index/4.0)
	AudioServer.set_bus_volume_db(0, linear_to_db(volume_index/4.0))
	AudioHandler.playSound("ui_click")
