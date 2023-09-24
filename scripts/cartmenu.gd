extends TileMap

var luggage_scene = preload("res://sprites/luggage.tscn")

onready var world = get_parent()

var last_time:int = 0

var just_opened:bool

var _cart:Cart

var _item:Luggage

signal on_cartmenu_close(item)

func open(cart:Cart, item:Luggage):
  visible = true
  just_opened = true
  _item = item
  _cart = cart
  if item:
    item.preview = true
    item.hover(false)
    item.get_parent().remove_child(item)
    add_child(item)
    item.position = Vector2(32, 96)

func close():
  visible = false
  yield(get_tree(), "idle_frame")
#  if _item:
#    _item.preview = false
  _item = null
  emit_signal('on_cartmenu_close', _item)

func _process(delta: float) -> void:
  if !visible:
    return
  var time = world.get_time()
  if time != last_time:
    last_time = time
    $time.text = Time.get_time_string_from_unix_time(time)
  if Input.is_action_just_pressed("pick_item") && !just_opened:
    close()
  just_opened = false
