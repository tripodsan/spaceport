extends TileMap

onready var points = get_node('%game_over_points')
onready var score = get_node('%game_over_score')

signal on_game_over_close()

func _ready() -> void:
  visible = false
  set_process_input(false)

## caluclates the new score and animates it
func open(flight:Flight, total_score):
  visible = true
  set_process_input(true)
  score.text = 'SCORE: %d' % total_score
  points.text = 'FLIGHT TO %s\nLEFT WITH %d\nMISSING ITEMS.' % [Globals.destinations[flight.destination], flight.get_num_unloaded()]

func close():
  visible = false
  set_process_input(false)
  yield(get_tree(), "idle_frame")
  emit_signal('on_game_over_close')

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('pick_item'):
    close()
