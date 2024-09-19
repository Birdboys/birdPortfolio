extends Node
 
@onready var soundQueue := $soundEffectQueue
@onready var bgMusicPlayer := $bgMusicPlayer
@onready var players := []
@onready var queue_length := 10
@onready var queue_index := 0
@onready var audio_num_vars = {"ui_click":3, "ui_hover":4, "birdhouse_bop":4
}

var music_tween

func _ready():
	populateQueues()

func populateQueues():
	for x in range(queue_length):
		var new_player = AudioStreamPlayer.new()
		soundQueue.add_child(new_player)
		new_player.bus = "soundEffects"
		players.append(new_player)

func getAudio(audio):
	var audio_name = audio
	if audio_name in audio_num_vars: audio_name = "%s/%s" % [audio_name, randi_range(0, audio_num_vars[audio_name]-1)]
	var sound_stream = load("assets/sounds/%s.wav" % audio_name)
	return sound_stream
	
func playSound(audio):
	var current_player : AudioStreamPlayer = players[queue_index] 
	queue_index = wrapi(queue_index+1, 0, queue_length-1)
	if current_player.playing: current_player.stop()
	current_player.stream = getAudio(audio)
	current_player.play()
	

func setPlayer(player, val):
	match player:
		"music": bgMusicPlayer.volume_db = val

func tweenPlayer(player, val, time=1.0):
	match player:
		"music":
			if music_tween: music_tween.kill()
			music_tween = get_tree().create_tween()
			music_tween.tween_property(bgMusicPlayer, "volume_db", val, time)
		
func togglePlayer(player, on):
	match player:
		"music": bgMusicPlayer.playing = on
