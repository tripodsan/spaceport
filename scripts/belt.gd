extends TileMap


var luggage_scene = preload("res://sprites/luggage.tscn")

var belt_speed = 10

var margin = 6

var belt_frame = 0

var next:Luggage;

var first:Luggage;

var last:Luggage;

var paused:bool = true

func _ready() -> void:
  randomize()
  prepare_luggage()

func _physics_process(delta):
  if paused:
    return
  belt_frame += belt_speed * delta
  if belt_frame >= 1.0:
    belt_frame -= 1.0
    move_belt()
    move_luggage()

func prepare_luggage():
  next = luggage_scene.instance()
  next.set_random_type()
  add_child(next)
  next.position = Vector2(-100, -100)
  next.visible = false

func add_luggage():
  if !first || first.position.x >= 0:
    remove_child(next)
    $luggage.add_child(next)
    next.visible = true
    next.position = Vector2(-next.size.x - margin, 134);
    first = next
    prepare_luggage()

func move_luggage():
  first = null
  last = null
  for child in $luggage.get_children():
    child.position.x += 1
    if !first || child.position.x < first.position.x:
      first = child
    if !last || child.position.x > last.position.x:
      last = child
  if last && last.position.x > 160:
    last.position.x = min(0, first.position.x) - last.size.x - margin
    first = last
  add_luggage()

func move_belt():
  $surface.position.x += 1.0
  if ($surface.position.x >= 4.0):
    $surface.position.x -= 4.0

