extends Label

class_name Ticker

var lines:Array = []

var idx:int = 0

var time:float = 0

const DISPLAY_TIME = 3.0

var paused:bool = true

var updating:bool = false

var blink:int = -1

onready var y_start_pos = rect_position.y

func _ready() -> void:
  lines.push_back('Departures')
  update_text()

func add_line(line):
  blink = lines.size()
  time = DISPLAY_TIME
  lines.push_back(line)

func remove_line(line):
  var i = lines.find(line)
  if i >= 0:
    lines.remove(i)
    idx = 0
    update_text()

func update_text():
  text = str(lines[idx])

func blink_visibilty(value:int):
  visible = value % 2 == 0

func show_next():
  updating = true
  if blink > 0:
    idx = blink
    blink = -1
    assert($Tween.interpolate_method(self, 'blink_visibilty', 0, 6, 1, Tween.TRANS_LINEAR))
    $Tween.start()
    yield($Tween, "tween_all_completed")
    visible = true
  else:
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
    if time >= DISPLAY_TIME:
      time -= DISPLAY_TIME
      show_next()
  update_text()
