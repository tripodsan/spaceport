extends Node2D

func _ready() -> void:
  assert(!$player.connect('on_item_pick', self, '_on_player_item_pick'))
  assert(!$player.connect('on_item_drop', self, '_on_player_item_drop'))


func _on_player_item_pick(item):
  $preview.show_item(item)

func _on_player_item_drop(item):
  $preview.show_item(null)
