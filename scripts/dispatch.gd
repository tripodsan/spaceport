extends TileMap

signal on_control_panel_close()

signal on_cart_dispatch(cart)

var _cart

func _ready() -> void:
  visible = false
  set_process_input(false)

func open(cart):
  _cart = cart
  yield(get_tree(), "idle_frame")
  set_process_input(true)
  visible = true
  $VBoxContainer/back.grab_focus()

func close():
  set_process_input(false)
  visible = false
  emit_signal('on_control_panel_close')

func _on_back_pressed() -> void:
  close()

func dispatch_cart():
  emit_signal('on_cart_dispatch', _cart)
  close()

func _on_Label2_pressed() -> void:
  dispatch_cart()

func _on_Label3_pressed() -> void:
  dispatch_cart()
