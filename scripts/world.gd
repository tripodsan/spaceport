extends Node2D

var flight_scene = preload("res://sprites/flight.tscn")

onready var player:Player = get_node('%player')

onready var ticker:Ticker = get_node('%ticker')

onready var flights:Node2D = get_node('%flights')

var score:int = -1

var flight_nr:int = -1

var next_stage_time = 0

func _ready() -> void:
  randomize()
  assert(!player.connect('on_item_drop', self, '_on_player_item_drop'))
  assert(!player.connect('on_open_cart', self, '_on_player_open_cart'))
  assert(!player.connect('on_open_control_panel', self, '_on_player_open_control_panel'))
  assert(!player.connect('on_item_pick', self, '_on_player_item_pick'))
  assert(!player.connect('on_item_hover', self, '_on_player_item_hover'))
  assert(!$cartmenu.connect('on_cartmenu_close', self, '_on_cartmenu_close'))
  assert(!$depart.connect('on_depart_close', self, '_on_depart_close'))
  assert(!$game_over.connect('on_game_over_close', self, '_on_game_over_close'))
  assert(!$dispatch.connect('on_control_panel_close', self, '_on_control_panel_close'))
  assert(!$dispatch.connect('on_cart_dispatch', self, '_on_cart_dispatch'))
  assert(!Globals.connect('game_over', self, '_on_game_over'))

func _on_game_over(flight:Flight):
  stop_game()
  player.visible = false
  $game_over.open(flight, score)

func _on_game_over_close():
  Globals.emit_signal('reset')

func _on_player_item_pick(item):
  $preview.show_item(item)

func _on_player_item_hover(item):
  $preview.show_item(item)

# warning-ignore:unused_argument
func _on_player_item_drop(item):
  $preview.show_item(null)

func _on_player_open_cart(cart, item):
  player.pause(true)
  $cartmenu.open(cart, item)

func _on_player_open_control_panel(cart_controller:CartController):
  if cart_controller.can_open():
    $dispatch.open(cart_controller, flights.get_children())
    player.pause(true)

func _on_cartmenu_close(item):
  player.pause(false)
  if item:
    player.take_item(item)

func _on_control_panel_close():
  player.pause(false)

func start_game():
  flight_nr = 0
  score = 0
  next_stage_time = 0
  Globals.start()
  $bg_music.play()
  $belt.start()
  player.visible = true
  ticker.pause(false)
  player.pause(false)
  yield(get_tree().create_timer(2.5),"timeout")
  create_flight()


func stop_game():
  $bg_music.stop()
  $belt.paused = true
  next_stage_time = 0
  ticker.pause(true)
  player.pause(true)
  Globals.stop()

func _on_cart_dispatch(cart:Cart, flight:Flight):
  flight.add_cart(cart)
  print_flights()
  if flight.num_loaded < flight.num_lugages:
    return
  ticker.pause(true)
  player.pause(true)
  $belt.paused = true
  $bg_music.stop()
  flights.remove_child(flight)
  ticker.remove_line(flight)
  score = $depart.open(flight.num_lugages, flight.get_cart_count(), flight.carts_par, flight.get_time_remaining(), score)

func _on_depart_close():
  create_flight();
  $belt.start()
  $bg_music.play()
  ticker.pause(false)
  player.pause(false)

var flight_plan = [
  { destination = 'MON', dock = 'A', time = 3*60, lug = [0] },
  { destination = 'EUR', dock = 'B', time = 3*60, lug = [1] },
  { destination = 'MON', dock = 'C', time = 3*60, lug = [2] },
 ]

func get_concurrency():
  if flight_nr < 4:
    return 2
  elif flight_nr < 10:
    return 3
  else:
    return 4

func get_flight_time():
  if flight_nr < 4:
    return 3*60
  elif flight_nr < 10:
    return 2*60
  else:
    return 100

func get_flight_by_destination(dest:String)->Flight:
  for i in flights.get_children():
    var f:Flight = i
    if f.destination == dest:
      return f
  return null

func get_flight_by_dock(dock:String)->Flight:
  for i in flights.get_children():
    var f:Flight = i
    if f.dock == dock:
      return f
  return null

func get_available_destination():
  var keys = Globals.destinations.keys()
  keys.shuffle()
  for dest in keys:
    if get_flight_by_destination(dest) == null:
      return dest
  assert(false, 'destination missmatch!')

func get_free_dock():
  Globals.docks.shuffle()
  for dock in Globals.docks:
    if get_flight_by_dock(dock) == null:
      return dock
  assert(false, 'dock missmatch!')

func _process(delta: float) -> void:
  if next_stage_time && Globals.get_time() > next_stage_time:
    next_stage_time = 0
    create_flight()

func create_flight():
  if flights.get_child_count() >= get_concurrency():
    print_debug('already enough flights')
    return
  var f:Flight = flight_scene.instance()
  flights.add_child(f)
  if flight_nr == 0:
    f.init_from_plan(flight_plan[0])
  elif flight_nr == 1:
    f.init_from_plan(flight_plan[1])
    next_stage_time = Globals.get_time() + 10
  elif flight_nr == 2:
    f.init_from_plan(flight_plan[2])
    next_stage_time = 0
  else:
    f.time = Globals.get_time() + get_flight_time()
    f.destination = get_available_destination()
    f.dock = get_free_dock()
    next_stage_time = Globals.get_time() + 30
    var sets = [0,1,2,3]
    sets.shuffle()
    f.add_luggage(sets.pop_back())
    f.add_luggage(sets.pop_back())
  flight_nr += 1
  ticker.add_line(f)
  $belt.prepare_luggage()
  $sfx_ding_dong.play()
  print_flights()

func get_next_luggage()->Luggage:
  var fs = []
  for i in flights.get_children():
    var f:Flight = i
    if f.get_luggage_count() > 0:
      fs.push_back(f)
  if fs.size() == 0:
    return null
  fs.shuffle()
  return fs[0].remove_random_luggage()

func print_flights():
  print('---------------------------------')
  for i in flights.get_children():
    var f:Flight = i
    print('%s total=%d loaded=%d' % [f, f.num_lugages, f.num_loaded])
