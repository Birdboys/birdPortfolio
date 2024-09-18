extends TextureButton

func _ready() -> void:
	toggled.connect(toggleVolume)
	
func toggleVolume(off: bool):
	if not off: AudioServer.set_bus_volume_db(0, 0)
	else: AudioServer.set_bus_volume_db(0, -60)
	AudioHandler.playSound("ui_click")
