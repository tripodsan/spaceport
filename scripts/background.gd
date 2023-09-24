extends TileMap

var speed = 1

func _physics_process(delta):
  position.x -= delta * speed
  if position.x <= -160:
    position.x += 160
