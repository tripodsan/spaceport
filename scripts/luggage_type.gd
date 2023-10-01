extends Node2D

class_name LuggageType

export var dimension:Vector2

var preview:bool = false

var pickable:bool = false

var hover:bool = false

func set_enabled(v):
  visible = v
  $small/CollisionShape2D.disabled = !v

func set_preview(v):
  $small.visible = !v
  $small/sprite.visible = !hover
  $small/hover.visible = hover
  $large.visible = v
  preview = v
  set_pickable(pickable)

func set_pickable(v:bool):
  pickable = v
  $small/CollisionShape2D.set_deferred("disabled", !v or preview)

func set_hover(enable):
  hover = enable
  set_preview(preview)

func get_size() -> Vector2:
  var sprite = $large if preview else $small/sprite;
  return sprite.get_rect().size
