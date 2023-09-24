extends Control

func show():
  visible = true
  $MarginContainer/VBoxContainer/start.grab_focus()

func hide():
  visible = false
