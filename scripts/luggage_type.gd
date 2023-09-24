extends Node2D

class_name LuggageType

export var dimension:Vector2

var preview:bool = false

func set_enabled(v):
  visible = v
  $small/CollisionShape2D.disabled = !v

func set_preview(v):
  $small.visible = !v
  $small/CollisionShape2D.disabled = v
  $large.visible = v
  preview = v

func get_size() -> Vector2:
  var sprite = $large if preview else $small/sprite;
  return sprite.get_rect().size
