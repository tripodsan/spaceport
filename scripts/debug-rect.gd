tool
extends Polygon2D

export var size:Vector2 = Vector2(100, 10) setget set_size

func set_size(v:Vector2):
  polygon[1] = Vector2(v.x, 0)
  polygon[2] = Vector2(v)
  polygon[3] = Vector2(0, v.y)
  size = v
