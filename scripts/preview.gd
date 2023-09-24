extends TileMap

var luggage_scene = preload("res://sprites/luggage.tscn")

var luggage:Luggage;

func _ready() -> void:
  visible = false

func show_item(item:Luggage):
  if luggage:
    luggage.queue_free()
    luggage = null
  if item:
    luggage = luggage_scene.instance()
    luggage.type = item.type
    luggage.preview = true
    add_child(luggage)
    luggage.position = Vector2(135 - luggage.size.x / 2, 116 + luggage.size.y / 2)
    $Label.text = luggage.destination
    visible = true
  else:
    visible = false
