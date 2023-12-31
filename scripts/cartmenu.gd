extends TileMap

onready var world = get_parent()

var _cart:Cart

var _item:Luggage

var _can_place:bool

var _heights = [0, 0, 0, 0, 0, 0];

const GRID_SIZE = Vector2(16, 16)

const WARN_FULL = 'CART FULL'

const WARN_TOO_BIG = 'ITEM TOO BIG'

const WARN_WRONG_DEST = 'WRONG DEST'

signal on_cartmenu_close(item)

func _ready() -> void:
  visible = false
  set_process_input(false)

func open(cart:Cart, item:Luggage):
  visible = true
  set_process_input(true)
  $dest.text = 'DEST: %s' % cart.destination
  $warning.visible = false
  _cart = cart
  _item = item
  _can_place = false
  if item:
    item.visible = false
  for item in cart.remove_items():
    item.preview = true
    $items.add_child(item)
    place_item(item)

  update_heights()
  cart.set_full(check_full())

  if cart.is_full():
    show_warning(WARN_FULL)
    return

  if item:
    if !cart.can_add(item):
      cart.set_full(true)
      show_warning(WARN_WRONG_DEST)
      return
    item.preview = true
    item.hover = false
    item.get_parent().remove_child(item)
    $items.add_child(item)
    var pos = find_fit(item.dimension, -1, 1)
    if pos.x < 0:
      cart.set_full(true)
      item.visible = false
      show_warning(WARN_TOO_BIG)
      return
    item.cart_position = pos
    item.visible = true
    _can_place = true
    place_item(item)

func show_warning(text:String):
  $warning.text = text
  $warning.visible = true

func update_heights():
  _heights = [0, 0, 0, 0, 0, 0]
  for item in $items.get_children():
    for idx in range(item.cart_position.x, item.cart_position.x + item.dimension.x):
      _heights[idx] = max(_heights[idx], item.cart_position.y + item.dimension.y)

func close():
  visible = false
  set_process_input(false)
  for item in $items.get_children():
    $items.remove_child(item)
    _cart.add_item(item)
  if _can_place:
    _item = null
  if _item:
    _item.visible = true
  _cart.set_full(check_full())
  yield(get_tree(), "idle_frame")
  emit_signal('on_cartmenu_close', _item)

func place_item(item:Luggage):
  item.position.x =   item.cart_position.x * GRID_SIZE.x
  item.position.y = - item.cart_position.y * GRID_SIZE.y

func check_full()->bool:
  return find_fit(Vector2(1, 1), -1, 1).x < 0

func move(dx):
  # warning-ignore:narrowing_conversion
  var new_pos = find_fit(_item.dimension, _item.cart_position.x, dx)
  if new_pos.x >= 0:
    _item.cart_position = new_pos
    place_item(_item)

func find_fit(dimension:Vector2, x:int, dx:int)->Vector2:
  x += dx
  while (x >= 0 && x <= 6 - dimension.x):
    var y = fit(dimension, x)
    if y >= 0:
      return Vector2(x, y)
    x += dx
  return Vector2(-1, -1)

## tries to fit the item at the given x position and returns the y position
## or -1 fif it doesn't fit
func fit(dimension:Vector2, x:int)->int:
  var y = 0
  for idx in range(x, x + dimension.x):
    y = max(y, _heights[idx] + dimension.y)
  return -1 if y > 4 else y - dimension.y

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('pick_item'):
    get_tree().set_input_as_handled()
    update_heights()
    close()
  if !_item:
    return
  if event.is_action_pressed('walk_left'):
    move(-1)
  if event.is_action_pressed('walk_right'):
    move(1)

