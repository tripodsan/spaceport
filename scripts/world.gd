extends Node2D

onready var player:Player = get_node('%player')

onready var ticker:Ticker = get_node('%ticker')

var flights:Array = []

func _ready() -> void:
  assert(!player.connect('on_item_drop', self, '_on_player_item_drop'))
  assert(!player.connect('on_open_cart', self, '_on_player_open_cart'))
  assert(!player.connect('on_open_control_panel', self, '_on_player_open_control_panel'))
  assert(!player.connect('on_item_pick', self, '_on_player_item_pick'))
  assert(!$cartmenu.connect('on_cartmenu_close', self, '_on_cartmenu_close'))
  assert(!$dispatch.connect('on_control_panel_close', self, '_on_control_panel_close'))
  assert(!$dispatch.connect('on_cart_dispatch', self, '_on_cart_dispatch'))

func _on_player_item_pick(item):
  $preview.show_item(item)

# warning-ignore:unused_argument
func _on_player_item_drop(item):
  $preview.show_item(null)

func _on_player_open_cart(cart, item):
  player.pause(true)
  $cartmenu.open(cart, item)

func _on_player_open_control_panel(cart):
  player.pause(true)
  $dispatch.open(cart)

func _on_cartmenu_close(item):
  player.pause(false)
  if item:
    player.take_item(item)

func _on_control_panel_close():
  player.pause(false)

func start():
  Globals.start()
  $bg_music.play()
  $belt.paused = false
  ticker.pause(false)
  player.pause(false)
  create_flight()

func stop():
  $bg_music.stop()
  $belt.paused = true
  ticker.pause(true)
  player.pause(true)
  Globals.stop()

func _on_cart_dispatch(cart):
  cart.clear()

func create_flight():
  var f = Flight.new(Globals.get_time() + 3*60, 'MON', 'A');
  flights.push_back(f)
  ticker.add_line(f)
  f = Flight.new(5*60, 'EUR', 'B');
  flights.push_back(f)
  ticker.add_line(f)

