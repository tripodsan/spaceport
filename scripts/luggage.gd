extends Node2D

class_name Luggage

var type:LuggageType

var type_idx = 0

func _ready():
  set_type(randi() % get_child_count())

func get_size():
  return type.size

func get_width():
  return type.get_width()

func _to_string() -> String:
  return "Luggage type %d %s" % [type_idx, type.size]

func set_type(idx):
  type_idx = idx;
  for child in get_children():
    child.visible = false
  type = get_child(idx)
  type.visible = true
