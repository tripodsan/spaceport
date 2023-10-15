extends KinematicBody2D

class_name Player

const SPEED_RUN:int = 60
const SPEED_WALK:int = 30

var idle_time = 0

onready var sprite:AnimatedSprite = $AnimatedSprite

onready var hands = $hands

var held_item:Luggage

var hover_item:Luggage

var hover_cart:Cart

var hover_control_panel:bool = false

var direction = 0

var moving = false

var DIR_NAME = ['_right', '_down', '_left', '_up']

var paused:bool = false

signal on_item_pick(item)

signal on_item_drop(item)

signal on_open_cart(cart, item)

signal on_open_control_panel(cart)

func take_item(item:Luggage):
  held_item = item
  held_item.get_parent().remove_child(held_item);
  hands.add_child(held_item)
  set_direction(direction)
  emit_signal('on_item_pick', held_item)

func pick_up():
  if hover_item and not held_item:
    take_item(hover_item)

  if hover_cart:
    if hover_control_panel:
      emit_signal('on_open_control_panel', hover_cart)
    else:
      emit_signal('on_open_cart', hover_cart, held_item)
      emit_signal('on_item_drop', held_item)
      held_item = null
#  elif held_item:
#    held_item.queue_free()
#    emit_signal('on_item_drop', held_item)
#    held_item = null

func set_direction(d):
  direction = d
  hands.scale = Vector2(-1 if direction == 2 else 1, 1)

  var anim:String;
  if held_item:
    anim = 'walk' if moving else 'wait'
    var dy = sprite.frame % 3 == 1
    if direction%2 == 0:
      held_item.position = Vector2(5, dy)
    else:
      held_item.position = Vector2(-held_item.size.x / 2, dy)
    if direction == 3:
      sprite.raise()
    else:
      hands.raise()

  else:
    anim = 'run' if moving else 'idle'
  sprite.play(anim + DIR_NAME[direction])


func _ready() -> void:
  pause(true)

func pause(enable):
  set_process_input(!enable)
  paused = enable

func _physics_process(delta):
  if paused:
    return
  var velocity = Vector2.ZERO
  var new_dir = direction
  var speed = SPEED_WALK if held_item else SPEED_RUN
  if Input.is_action_pressed("walk_right"):
    velocity.x = speed;
    new_dir = 0
  elif Input.is_action_pressed("walk_left"):
    velocity.x = -speed;
    new_dir = 2
  if Input.is_action_pressed("walk_down"):
    velocity.y = speed;
    new_dir = 1
  elif Input.is_action_pressed("walk_up"):
    velocity.y = -speed;
    new_dir = 3

  var new_moving = velocity != Vector2.ZERO;
  if new_moving:
    # warning-ignore:return_value_discarded
    move_and_collide(velocity * delta);
    idle_time = 0
  else:
    idle_time += delta
  if new_dir != direction or new_moving != moving:
    moving = new_moving
    set_direction(new_dir)

func _input(event):
  if event.is_action_pressed('pick_item'):
    pick_up()

func _on_hands_area_entered(area: Area2D) -> void:
  hover_control_panel = area.name == 'ControlPanel'
  var p = area.get_parent()
  var pp = p.get_parent()
  if p is Luggage:
    if hover_item:
      hover_item.set_hover(false)
    if held_item:
      hover_item = null
    else:
      hover_item = p
      p.set_hover(true)
  if pp is Cart:
    hover_cart = pp


func _on_hands_area_exited(area: Area2D) -> void:
  if area.name == 'ControlPanel':
    hover_control_panel = false
  var p = area.get_parent()
  var pp = p.get_parent()
#  prints(' exit', p)
  if p == hover_item:
    hover_item.set_hover(false)
    hover_item = null
  if pp == hover_cart:
    hover_cart = null

func _on_AnimatedSprite_frame_changed() -> void:
  set_direction(direction)
