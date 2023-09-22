extends KinematicBody2D

export var speed:int = 60

var idle_time = 0

onready var sprite:AnimatedSprite = $AnimatedSprite

func _ready() -> void:
  pass

func _physics_process(delta):
  var velocity = Vector2.ZERO
  if Input.is_action_pressed("walk_right"):
    velocity.x = speed;
    sprite.play('right')
  elif Input.is_action_pressed("walk_left"):
    velocity.x = -speed;
    sprite.play('left')
  if Input.is_action_pressed("walk_down"):
    velocity.y = speed;
    sprite.play('down')
  elif Input.is_action_pressed("walk_up"):
    velocity.y = -speed;
    sprite.play('up')
  if velocity != Vector2.ZERO:
    idle_time = 0
    move_and_collide(velocity * delta);
  else:
    idle_time += delta
    if (idle_time > 2):
      sprite.play('idle')

