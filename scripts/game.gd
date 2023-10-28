extends Node2D

func _ready():
  assert(!Globals.connect('reset', self, '_on_reset'))
  _on_reset()

func _on_reset():
  $mate.show()
  $credits.hide()
  $help.hide()
  $title.show()

func _on_start_pressed() -> void:
  yield($mate.fade(), 'completed')
  $world.show()
  $title.hide()
  yield($mate.show(), 'completed')
  $world.start_game()

func _on_credits_pressed() -> void:
  yield($mate.fade(), 'completed')
  $credits.show()
  $title.hide()
  yield($mate.show(), 'completed')

func _on_exit_pressed() -> void:
  get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_menu_pressed() -> void:
  yield($mate.fade(), 'completed')
  $credits.hide()
  $help.hide()
  $title.show()
  yield($mate.show(), 'completed')

func _on_help_pressed() -> void:
  yield($mate.fade(), 'completed')
  $title.hide()
  $help.show()
  yield($mate.show(), 'completed')
