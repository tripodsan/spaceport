extends Node2D

func _ready():
  $mate.show()
  $credits.hide()
  $title.show()

func _on_start_pressed() -> void:
  yield($mate.fade(), 'completed')
  $world.show()
  $title.hide()
  yield($mate.show(), 'completed')

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
  $title.show()
  yield($mate.show(), 'completed')
