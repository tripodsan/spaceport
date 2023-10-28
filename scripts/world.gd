extends Node2D

var flight_scene = preload("res://sprites/flight.tscn")

onready var player:Player = get_node('%player')

onready var ticker:Ticker = get_node('%ticker')

onready var flights:Node2D = get_node('%flights')

var score:int = -1

var flight_nr:int = -1

func _ready() -> void:
  randomize()
  assert(!player.connect('on_item_drop', self, '_on_player_item_drop'))
  assert(!player.connect('on_open_cart', self, '_on_player_open_cart'))
  assert(!player.connect('on_open_control_panel', self, '_on_player_open_control_panel'))
  assert(!player.connect('on_item_pick', self, '_on_player_item_pick'))
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
  Globals.start()
  create_flight()
  $bg_music.play()
  $belt.start()
  player.visible = true
  ticker.pause(false)
  player.pause(false)

func stop_game():
  $bg_music.stop()
  $belt.paused = true
  ticker.pause(true)
  player.pause(true)
  Globals.stop()

func _on_cart_dispatch(cart:Cart, flight:Flight):
  flight.add_cart(cart)
  if flight.get_luggage_count() > 0:
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
  { destination = 'MON', dock = 'A', time = 3*60, lug = [1] },
  { destination = 'EUR', dock = 'B', time = 3*60, lug = [2] },
 ]

func create_flight():
  var f:Flight = flight_scene.instance()
  flights.add_child(f)
  f.init_from_plan(flight_plan[flight_nr])
  ticker.add_line(f)

func get_next_luggage()->Luggage:
  var fs = []
  for f in flights.get_children():
    if f.get_luggage_count() > 0:
      fs.push_back(f)
  if fs.size() == 0:
    return null
  var idx = randi() % fs.size()
  return fs[idx].remove_random_luggage()
