extends Node2D

class_name LuggageType

export var size:Vector2

func get_width() -> float:
  return $small/sprite.get_rect().size.x
