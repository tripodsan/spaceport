extends TileMap

signal on_control_panel_close()

signal on_cart_dispatch(cart, flight)

var _cart_controller:CartController

var buttons:Array = []

var _flights = [];

var can_open:bool = true

func _ready() -> void:
  visible = false
  set_process_input(false)
  buttons = [
    $VBoxContainer/btn0,
    $VBoxContainer/btn1,
    $VBoxContainer/btn2,
    $VBoxContainer/btn3
  ]

func open(cart_controller:CartController, flights:Array):
  _cart_controller = cart_controller
  _flights = flights
  var idx = 0
  for btn in buttons:
    if idx < flights.size():
      var flight:Flight = flights[idx]
      btn.text = ' DOCK %s' % flight.dock
      btn.visible = true
      btn.connect('pressed', self, '_on_button_pressed', [flight])
    else:
      btn.visible = false
    idx += 1
  yield(get_tree(), "idle_frame")
  set_process_input(true)
  visible = true
  $VBoxContainer/back.grab_focus()

func close():
  _cart_controller = null
  _flights = []
  for btn in buttons:
    if btn.is_connected('pressed', self, '_on_button_pressed'):
      btn.disconnect('pressed', self, '_on_button_pressed')
  set_process_input(false)
  visible = false
  emit_signal('on_control_panel_close')

func _on_back_pressed() -> void:
  close()

func dispatch_cart(flight:Flight):
  var ctrl:CartController = _cart_controller
  close()
  yield(ctrl.move_to_hatch(false), 'completed')
  var cart = ctrl.new_cart()
  yield(ctrl.move_from_hatch(), 'completed')
  emit_signal('on_cart_dispatch', cart, flight)

func _on_button_pressed(flight) -> void:
  dispatch_cart(flight)

