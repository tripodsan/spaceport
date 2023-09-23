extends TileMap


var luggage_scene = preload("res://sprites/luggage.tscn")

var belt_speed = 8

var belt_frame = 0

var next:Luggage;

var first;

func _ready() -> void:
  prepare_luggage()

func _physics_process(delta):
  belt_frame += belt_speed * delta
  if belt_frame >= 1.0:
    belt_frame -= 1.0
    move_belt()
    move_luggage()

func prepare_luggage():
  next = luggage_scene.instance()
  add_child(next)
  next.visible = false

func add_luggage():
  if !first:
    return
  if first.position.x > next.get_width():
    remove_child(next)
    $luggage.add_child(next)
    next.visible = true
    next.position = Vector2(-next.get_width(), 134);
    first = next
    prepare_luggage()

func move_luggage():
  first = null
  var firstPos = 200
  for child in $luggage.get_children():
    child.position.x += 1
    if child.position.x > 160:
      child.position.x = -child.get_width()
    if child.position.x < firstPos:
      first = child
      firstPos = child.position.x
  add_luggage()

func move_belt():
  $surface.position.x += 1.0
  if ($surface.position.x >= 4.0):
    $surface.position.x -= 4.0

