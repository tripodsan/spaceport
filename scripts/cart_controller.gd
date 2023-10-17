extends StaticBody2D

class_name CartController

var cart_scene = preload('res://sprites/cart.tscn')

const GRID_SIZE = Vector2(8, 8)

var full:bool = false

onready var _cart:Cart = $cart_holder/cart

onready var _blink:AnimationPlayer = get_node('%blink')

onready var cart_animation:AnimationPlayer = $cart_animation

onready var hatch:AnimatedSprite = get_node('%hatch')

func _ready():
  add_cart(_cart)

func add_cart(cart:Cart):
  _cart = cart
  set_full(_cart.is_full())
  assert(!_cart.connect('cart_full_changed', self, '_on_cart_full_changed'))
  if cart.get_parent() != $cart_holder:
    $cart_holder.add_child(cart)

func _on_cart_full_changed(v):
  set_full(v)

func set_full(v):
  if v:
    _blink.play('blink')
  else:
    _blink.stop(true)
    _blink.seek(0)

func get_cart()->Cart:
  return _cart;

func remove_cart()->Cart:
  var cart = _cart
  if cart:
    $cart_holder.remove_child(cart)
    _cart = null
    cart.disconnect('cart_full_changed', self, '_on_cart_full_changed')
    set_full(false)
  return cart

func new_cart()->Cart:
  var old_cart = remove_cart()
  add_cart(cart_scene.instance())
  return old_cart

func can_open()->bool:
  return hatch.frame == 0

func move_to_hatch(close):
  hatch.play('default')
  yield(hatch, 'animation_finished')
  cart_animation.play('move_down')
  yield(cart_animation, 'animation_finished')
  if close:
    hatch.play('default', true)
    yield(hatch, 'animation_finished')

func move_from_hatch():
  if hatch.frame == 0:
    hatch.play('default')
    yield(hatch, 'animation_finished')
  cart_animation.play_backwards('move_down')
  yield(cart_animation, 'animation_finished')
  hatch.play('default', true)
  yield(hatch, 'animation_finished')
