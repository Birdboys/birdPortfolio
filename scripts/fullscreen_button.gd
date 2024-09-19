extends TextureButton

func _ready() -> void:
	toggled.connect(toggleFullscreen)
	
func toggleFullscreen(on: bool):
	if on: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioHandler.playSound("ui_click")
