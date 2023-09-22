extends Label

export (float) var scroll_speed = 15

var pos:float setget set_pos

func set_pos(v):
  pos = v
  rect_position.x = floor(pos / 2) * 2

func _ready() -> void:
  reset()

func reset():
  self.pos = get_parent().get_rect().size.x;

func _process(delta):
  self.pos -= scroll_speed * delta
  if pos < -rect_size.x:
    reset()
