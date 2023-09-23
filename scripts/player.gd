extends KinematicBody2D

export var speed:int = 60

var idle_time = 0

onready var sprite:AnimatedSprite = $AnimatedSprite

var held_item:Luggage

var hover_item:Luggage

var direction = 0

func pick_up():
  if hover_item and not held_item:
    held_item = hover_item
    held_item.get_parent().remove_child(held_item);
    $hands.add_child(held_item)
    held_item.position = Vector2(7, 6)
    set_direction(direction)
    print_debug("pick up: ", held_item)
  elif held_item:
    held_item.queue_free()
    held_item = null

func set_direction(d):
  direction = d
  $hands.scale = Vector2(direction, 1)
  sprite.play('right' if d == 1 else 'left')

func _ready() -> void:
  pass

func _physics_process(delta):
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
    move_and_collide(velocity * delta);
  else:
    idle_time += delta
    if (idle_time > 2):
      sprite.play('idle')
  if Input.is_action_just_pressed("pick_item"):
    pick_up()


func _on_hands_body_entered(body: Node) -> void:
  var p = body.get_parent().get_parent()
  if p is Luggage:
    hover_item = p
  else:
    hover_item = null

func _on_hands_body_exited(body: Node) -> void:
  var p = body.get_parent().get_parent()
  if p == hover_item:
    hover_item = null
