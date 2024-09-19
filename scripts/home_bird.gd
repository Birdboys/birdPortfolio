extends Sprite2D
class_name Bird

@onready var birdButton := $birdButton
@onready var click_timeout := 1.5
@onready var can_click := false
@onready var click_on_cooldown := false
signal button_pressed

func _ready() -> void:
	birdButton.get_child(0).shape.size = texture.get_size() * 1.5
	birdButton.input_event.connect(birdClick)
	
func birdClick(_viewport, input: InputEvent, _shape):
	if not can_click or click_on_cooldown: return
	if not (input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT and input.pressed): return
	emit_signal("button_pressed")
	click_on_cooldown = true
	var click_tween = get_tree().create_tween()
	click_tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.0)
	click_tween.tween_property(self, "scale", Vector2(1.00,1.00), 0.2)
	click_tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.0)
	click_tween.tween_property(self, "scale", Vector2(1.00,1.00), 0.2)
	click_tween.tween_interval(click_timeout-0.4)
	click_tween.tween_callback(resetCooldown)

func resetCooldown():
	click_on_cooldown = false
