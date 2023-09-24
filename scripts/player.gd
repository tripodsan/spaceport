extends KinematicBody2D

export var speed:int = 60

var idle_time = 0

onready var sprite:AnimatedSprite = $AnimatedSprite

var held_item:Luggage

var hover_item:Luggage

var hover_cart:Cart

var direction = 0

var pause:bool = false

signal on_item_pick(item)

signal on_item_drop(item)

signal on_open_cart(cart, item)

func take_item(item):
  held_item = item
  held_item.get_parent().remove_child(held_item);
  $hands.add_child(held_item)
  held_item.position = Vector2(1, 6)
  set_direction(direction)
  emit_signal('on_item_pick', held_item)

func pick_up():
  if hover_item and not held_item:
    take_item(hover_item)

  if hover_cart:
    emit_signal('on_open_cart', hover_cart, held_item)
    emit_signal('on_item_drop', held_item)
    held_item = null
#  elif held_item:
#    held_item.queue_free()
#    emit_signal('on_item_drop', held_item)
#    held_item = null

func set_direction(d):
  direction = d
  $hands.scale = Vector2(direction, 1)
  $hands.position.x = direction * 6;
  sprite.play('right' if d == 1 else 'left')

func _ready() -> void:
  pass

func _physics_process(delta):
  if pause:
    return
  var velocity = Vector2.ZERO
  if Input.is_action_pressed("walk_right"):
    velocity.x = speed;
    set_direction(1)
  elif Input.is_action_pressed("walk_left"):
    velocity.x = -speed;
    set_direction(-1)
  if Input.is_action_pressed("walk_down"):
    velocity.y = speed;
    set_direction(direction)
#    sprite.play('down')
  elif Input.is_action_pressed("walk_up"):
    velocity.y = -speed;
    set_direction(direction)
#    sprite.play('up')
  if velocity != Vector2.ZERO:
    idle_time = 0
    var r = move_and_collide(velocity * delta);
  else:
    idle_time += delta
#    if (idle_time > 2):
#      sprite.play('idle')
  if Input.is_action_just_pressed("pick_item"):
    pick_up()

func _on_hands_area_entered(area: Area2D) -> void:
  var p = area.get_parent().get_parent()
#  prints('enter', p)
  if p is Luggage:
    if hover_item:
      hover_item.hover(false)
    hover_item = p
    p.hover(true)
  if p is Cart:
    hover_cart = p


func _on_hands_area_exited(area: Area2D) -> void:
  var p = area.get_parent().get_parent()
#  prints(' exit', p)
  if p == hover_item:
    hover_item.hover(false)
    hover_item = null
  if p == hover_cart:
    hover_cart = null
