extends CanvasLayer

@onready var backButton := $projectControl/marginCont/backButton
@onready var projectControl := $projectControl
@onready var projectScreenAnim := $projectScreenAnim
var active := false

signal back_to_home

func _ready() -> void:
	backButton.pressed.connect(goBack)
	backButton.mouse_entered.connect(toggleShadow.bind(backButton, true))
	backButton.mouse_exited.connect(toggleShadow.bind(backButton, false))
	reset()

func toggleShadow(button, on: bool):
	print("GORBA")
	if not active: return
	button.get_child(0).visible = on
	if on: AudioHandler.playSound("ui_click")
		
func loadMenu():
	visible = true
	projectScreenAnim.play_backwards("fade_out")
	await projectScreenAnim.animation_finished
	active = true
	
func goBack():
	if not active: return
	active = false
	projectScreenAnim.play("fade_out")
	await projectScreenAnim.animation_finished
	visible = false
	emit_signal("back_to_home")
	
func reset():
	visible = false
	projectControl.modulate = Color.TRANSPARENT
