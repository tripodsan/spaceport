extends Node2D

class_name Cart

const GRID_SIZE = Vector2(8, 8)

var full:bool = false

func _ready() -> void:
#  set_full(true)
  pass # Replace with function body.

func remove_items()->Array: #->Array[Luggage]:
  var items = []
  for item in $items.get_children():
    items.push_back(item)
    $items.remove_child(item)
  return items

func clear():
  for item in $items.get_children():
    item.queue_free()
  set_full(false)

func set_full(v):
  full = v
  if v:
    $control/control_lamp/blink.play('blink')
  else:
    $control/control_lamp/blink.seek(0, true)
    $control/control_lamp/blink.stop(true)

func add_item(item:Luggage):
  item.preview = false
  item.set_pickable(false)
  $items.add_child(item)
  item.position.x =   item.cart_position.x * GRID_SIZE.x + 1
  item.position.y = - item.cart_position.y * GRID_SIZE.y + 1
