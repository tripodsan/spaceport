extends TileMap

var luggage:Luggage;

## dictionay of preview items
var items:Dictionary

func _ready() -> void:
  visible = false

func show_item(item:Luggage):
  if luggage:
    luggage.visible = false
    luggage = null

  if item:
    luggage = items.get(item.filename)
    if !luggage:
      luggage = item.clone()
      luggage.preview = true
      items[item.filename] = luggage
      $item.add_child(luggage)
      luggage.position = Vector2(-luggage.size.x / 2, luggage.size.y / 2)
    luggage.visible = true
    $Label.text = item.destination
    visible = true
  else:
    visible = false
