extends Node2D

class_name Luggage

export var dimension:Vector2

export(String) var destination = '???'

var size:Vector2 setget , get_size

var cart_position:Vector2 = Vector2.ZERO

onready var self_scene:Resource = load(filename)

var preview:bool setget set_preview

var pickable:bool setget set_pickable

var hover:bool setget set_hover

func _ready():
  set_hover(false)
  set_preview(false)
  set_pickable(false)
  set_enabled(true)

func clone()->Luggage:
  return self_scene.instance()

func set_enabled(v):
  visible = v
  $small/CollisionShape2D.disabled = !v

func set_preview(v):
  preview = v
  $small.visible = !v
  $large.visible = v

func set_pickable(v:bool):
  pickable = v
  $small/CollisionShape2D.set_deferred("disabled", !v or preview)

func set_hover(enable):
  hover = enable
  $small/hover.visible = hover

func get_size() -> Vector2:
  var sprite = $large if preview else $small/sprite;
  return sprite.get_rect().size

