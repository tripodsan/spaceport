extends Node2D

var game_start:int

var beginning_of_time = Time.get_unix_time_from_datetime_string('2034-04-01T08:00:00Z')

onready var player = $YSort/player

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
  $bg_music.play()
  $belt.paused = false
  player.pause(false)
  game_start = Time.get_ticks_msec()

func get_time()->int:
  return (Time.get_ticks_msec() - game_start) / 1000 + beginning_of_time

func stop():
  $bg_music.stop()
  $belt.paused = true

func _on_cart_dispatch(cart):
  cart.clear()
