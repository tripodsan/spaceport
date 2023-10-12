extends Label

class_name Ticker

var lines:Array = []

var idx:int = 0

var time:float = 0

const DISPLAY_TIME = 3.0

var paused:bool = true

var updating:bool = false

onready var y_start_pos = rect_position.y

func _ready() -> void:
  lines.push_back('Departures')
  update_text()

func add_line(line):
  lines.push_back(line)

func update_text():
  text = str(lines[idx])

func show_next():
  updating = true
  $Tween.interpolate_property(self, "rect_position:y",
        y_start_pos, y_start_pos - 10, 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $Tween.start()
  yield($Tween, "tween_all_completed")
  idx = (idx + 1) % lines.size()
  $Tween.interpolate_property(self, "rect_position:y",
        y_start_pos - 10, y_start_pos, 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $Tween.start()
  yield($Tween, "tween_all_completed")
  updating = false

func pause(value):
  paused = value
#
#func reset():
#  self.pos = get_parent().get_rect().size.x;
#
func _process(delta):
  if paused: return
  if !updating:
    time += delta
    if time > DISPLAY_TIME:
      time -= DISPLAY_TIME
      show_next()
  update_text()
