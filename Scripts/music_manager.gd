extends Node2D

var current_song := 0
var songs: Array[AudioStreamPlayer] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		if c is AudioStreamPlayer:
			songs.append(c)
	_play_current()


func _process(_delta: float) -> void:
	if songs.is_empty():
		return
	if not songs[current_song].playing:
		_play_next_song()

func _play_current() -> void:
	songs[current_song].play()

func _play_next_song() -> void:
	current_song = (current_song + 1) % songs.size()
	_play_current()
