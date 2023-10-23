extends TileMap

onready var points = get_node('%points')
onready var score = get_node('%score')

const CARTS_MULT = 50
const ITEM_MULT = 10

var time = 0

var _items = 0
var _items_to
var _carts = 0
var _carts_to
var _carts_par
var _bonus = 0
var _bonus_to
var _score = 0
var _total = 0
var _total_to = 0

var anim_step = -1

var text = ['\n', '\n', '\n', '']

signal on_depart_close()

func _ready() -> void:
  visible = false
  set_process_input(false)
  _update_text()

## caluclates the new score and animates it
func open(items, carts, carts_par, bonus, score)->int:
  visible = true
  set_process_input(true)
  _items_to = items
  _carts_to = carts
  _carts_par = carts_par
  _bonus_to = bonus
  _total = 0
  _total_to = items*ITEM_MULT + (_carts_par - carts) * CARTS_MULT + bonus
  _score = score
  anim_step = 0
  time = 0
  text = ['\n', '\n', '\n', '']
  _update_text()
  _update_score()
  return score + _total_to

func _update_text():
  points.text = String.join(text)

func _update_score():
  score.text = 'SCORE: %d' % (_score + _total)

func _process(delta):
  if anim_step < 0:
    return
  time += delta * 20
  if time < 1:
    return
  time -= 1

  if anim_step == 0:
    _items += 1
    text[0] = 'items:%2d*%d=%3d\n' % [_items, ITEM_MULT, _items * ITEM_MULT]
    _update_text()
    if _items == _items_to:
      anim_step += 1
  if anim_step == 1:
    _carts += 1
    text[1] = 'carts:%2d(%d)=%3d\n' % [_carts, _carts_par, (_carts_par - _carts) * CARTS_MULT]
    _update_text()
    if _carts == _carts_to:
      anim_step += 1
  if anim_step == 2:
    _bonus = min(_bonus + 5, _bonus_to)
    text[2] = ' time bonus:%3d\n' % _bonus
    _update_text()
    if _bonus == _bonus_to:
      anim_step += 1
  if anim_step == 3:
    _total = min(_total + 10, _total_to)
    text[3] = '      total:%3d' % _total
    _update_text()
    _update_score()
    if _total == _total_to:
      anim_step = -1

func close():
  visible = false
  set_process_input(false)
  yield(get_tree(), "idle_frame")
  emit_signal('on_depart_close')

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('pick_item'):
    anim_step = -1
    close()
