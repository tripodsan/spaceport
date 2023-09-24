extends Button

func _ready() -> void:
  assert(!connect('focus_entered', self, '_on_focus_enter'))
  assert(!connect('focus_exited', self, '_on_focus_exited'))
  _on_focus_exited()

func _on_focus_enter():
  $Sprite.visible = true

func _on_focus_exited():
  $Sprite.visible = false
