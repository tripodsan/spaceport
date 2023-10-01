extends Node2D

class_name Luggage

export(int, 0, 5) var type = 0 setget set_type

export(bool) var preview = false setget set_preview

export(String) var destination = 'MON'

var dimension:Vector2 setget , get_dimension

var cart_position:Vector2 = Vector2.ZERO

var size:Vector2 setget , get_size

var type_node:LuggageType

func get_dimension()->Vector2:
  return type_node.dimension

func get_size() -> Vector2:
  return type_node.get_size()

func _to_string() -> String:
  return "Luggage type %d %s" % [type, type_node.dimension]

func hover(enable):
  type_node.set_hover(enable)

func set_pickable(v):
  type_node.set_pickable(v)

func set_preview(v):
  preview = v
  set_type(type)

func set_type(idx):
  type = idx;
  for child in get_children():
    child.set_enabled(false)

  type_node = get_child(idx)
  type_node.set_enabled(true)
  type_node.set_preview(preview)

func set_random_type():
  set_type(randi() % get_child_count())
