extends Node2D

class_name Cart

const GRID_SIZE = Vector2(8, 8)

var full:bool = false

onready var items_node:Node2D = get_node('%items')

signal cart_full_changed(is_full)

var destination:String = '???'

func remove_items()->Array: #->Array[Luggage]:
  var items = []
  for item in items_node.get_children():
    items.push_back(item)
    items_node.remove_child(item)
  return items

func set_full(v):
  if full != v:
    full = v
    emit_signal('cart_full_changed', full)

func is_full()->bool:
  return full

func can_add(item:Luggage)->bool:
  return destination == '???' or item.destination == destination

func add_item(item:Luggage):
  assert(can_add(item))
  destination = item.destination
  item.preview = false
  item.set_pickable(false)
  items_node.add_child(item)
  item.position.x =   item.cart_position.x * GRID_SIZE.x + 1
  item.position.y = - item.cart_position.y * GRID_SIZE.y + 1
