extends Node2D

@onready var mainCam := $mainCam
@onready var homeScreen := $homeScreen
@onready var aboutScreen := $aboutScreen
@onready var resumeScreen := $resumeScreen
@onready var contactScreen := $contactScreen
@onready var projectsScreen := $projectsScreen
@onready var openScreen := $openScreen
@onready var openTexture := $openScreen/openTexture
@onready var birdHandler := $birdHandler
@onready var birdhouse := $birdhouse
@onready var cam_home_pos := Vector2(-256, -156)
@onready var cam_about_pos := Vector2(-820, -640)
@onready var cam_resume_pos := Vector2(1264, 0)
@onready var cam_contact_pos := Vector2(-301, 944)
@onready var cam_project_pos := Vector2(-1456, 0)

var birdhouse_tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	homeScreen.button_enter.connect(birdHandler.birdHover)
	homeScreen.button_exit.connect(birdHandler.nullHoverBird)
	homeScreen.menu_transition.connect(birdHandler.birdFlyAway)
	homeScreen.reset_birds.connect(birdHandler.reset)
	birdHandler.menu_transition.connect(transitionMenu)
	birdHandler.tween_birdhouse.connect(tweenBirdhouse)
	contactScreen.email_birds.connect(birdHandler.emailBirds)
	
	mainCam.position = cam_home_pos
	var open_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	open_tween.tween_interval(1.0)
	open_tween.tween_property(openTexture, "modulate", Color.TRANSPARENT, 1.5)
	open_tween.tween_callback(openScreen.set_visible.bind(false))
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"): get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func tweenBirdhouse():
	if birdhouse_tween is Tween: birdhouse_tween.kill()
	birdhouse_tween = get_tree().create_tween()
	birdhouse_tween.tween_interval(0.05)
	birdhouse_tween.tween_property(birdhouse, "scale", Vector2(1.05, 1.05), 0.1)
	birdhouse_tween.tween_callback(AudioHandler.playSound.bind("birdhouse_bop"))
	birdhouse_tween.tween_property(birdhouse, "scale", Vector2(1.0, 1.0), 0.1)
	
func resetMenus():
	homeScreen.reset()
	aboutScreen.reset()
	resumeScreen.reset()
	projectsScreen.reset()
	
func transitionMenu(menu):
	var new_pos 
	var next_menu
	match menu:
		"about":
			aboutScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_about_pos
			next_menu = aboutScreen
		"projects":
			projectsScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_project_pos
			next_menu = projectsScreen
		"resume":
			resumeScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_resume_pos
			next_menu = resumeScreen
		"contact":
			contactScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_contact_pos
			next_menu = contactScreen
		"home":
			new_pos = cam_home_pos
			next_menu = homeScreen
	var cam_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	cam_tween.tween_property(mainCam, "position", new_pos, 1.0)
	cam_tween.tween_callback(next_menu.loadMenu)
	cam_tween.tween_callback(birdHandler.reset)
