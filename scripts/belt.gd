extends Node2D

const FEEDER_POS = 23

onready var world = get_parent()

var margin = 6

var next:Luggage;

var next_wait:bool = false

var paused:bool = true

var speed:int = 10

func _ready() -> void:
  set_speed(speed)

func _on_surface_frame_changed() -> void:
  if !paused:
    move_luggage()

func start():
  paused = false
  if !next:
    prepare_luggage()

func prepare_luggage():
  next = world.get_next_luggage()
  if next:
    $luggage.add_child(next)
    next.position = Vector2(FEEDER_POS - next.size.x/2, 144 + next.size.y)
    next.visible = true

func set_speed(s):
  speed = s
  $surface.play('default')
  $surface.frames.set_animation_speed('default', speed)
  if next_wait:
    $feeder.stop()
  else:
    $feeder.play('default')
    $feeder.frames.set_animation_speed('default', speed)

func move_luggage():
  var min_pos = 0
  var max_pos = 160
  var last:Luggage = null
  var first:Luggage = null
  for child in $luggage.get_children():
    if child != next:
      child.position.x += 1
      var x0 = child.position.x
      var x1 = x0 + child.size.x
      if x0 >= FEEDER_POS:
        max_pos = min(max_pos, x0)
      elif x1 >= FEEDER_POS:
        max_pos = 0
      if x1 <= FEEDER_POS:
        min_pos = max(min_pos, x1)
      elif x0 <= FEEDER_POS:
        min_pos = 160
      if !last or x0 > last.position.x:
        last = child
      if !first or x0 < first.position.x:
        first = child

  if last && last.position.x > 160:
      last.position.x = min(0, first.position.x) - last.size.x - margin

  if $debug.visible:
    if max_pos > min_pos:
      $debug.position.x = min_pos
      $debug.size = Vector2(max_pos - min_pos, 5)
    else:
      $debug.size = Vector2(0, 5)

  if !next:
    return

  if next_wait:
    # check if enough rooom
    var x0 = next.position.x - next.size.y
    var x1 = next.position.x + next.size.x
    if max_pos > x1 and min_pos < x0:
      next.position.y -= 1
      next_wait = false
      set_speed(speed)
  else:
    next.position.y -= 1

  if next.position.y == 132 + next.size.y + 1:
    next_wait = true
    set_speed(speed)
  if next.position.y == 132:
    next.set_pickable(true)
    prepare_luggage()
