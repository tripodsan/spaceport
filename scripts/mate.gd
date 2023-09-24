extends ColorRect

onready var tween = $Tween

var bg_transparent:Color;
var bg_opaque:Color;

func _ready() -> void:
  bg_transparent = color
  color.a = 1;
  bg_opaque = color

func show():
  tween.interpolate_property(self, "color",
        bg_opaque, bg_transparent, 0.5,
        Tween.TRANS_QUART, Tween.EASE_IN_OUT)
  tween.start()
  yield(tween, 'tween_completed')

func fade():
  tween.interpolate_property(self, "color",
        bg_transparent, bg_opaque, 0.5,
        Tween.TRANS_QUART, Tween.EASE_IN_OUT)
  tween.start()
  yield(tween, 'tween_completed')
