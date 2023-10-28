extends Node2D

class_name Flight

onready var luggage:Node2D = get_node('%luggage')

onready var carts:Node2D = get_node('%carts')

var luggage_set_scenes:Array = [
  preload("res://sprites/luggage_set0.tscn"),
  preload("res://sprites/luggage_set1.tscn"),
  preload("res://sprites/luggage_set2.tscn"),
  preload("res://sprites/luggage_set3.tscn"),
  preload("res://sprites/luggage_set4.tscn")
]

## time until departue
var time:int

## number of total lugages
var num_lugages:int

## number of optmimal carts
var carts_par:int = 0

var on_time:bool = true

## destination
export var destination:String

## departure dock
export var dock:String

func init_from_plan(plan:Dictionary):
  # 'destination': 'MON', 'dock': 'A', 'time': 3*60, 'lug': [1]
  destination = plan.destination
  dock = plan.dock
  time = Globals.get_time() + plan.time
  for s in plan.lug:
    add_luggage(s)

func add_luggage(set_nr:int):
  var set:Node2D = luggage_set_scenes[set_nr].instance()
  for lug in set.get_children():
    set.remove_child(lug)
    luggage.add_child(lug)
  num_lugages = luggage.get_child_count()
  carts_par += 1

func get_luggage_count()->int:
  return luggage.get_child_count()

func get_cart_count()->int:
  return carts.get_child_count()

func add_cart(cart:Cart):
  cart.visible = false
  carts.add_child(cart)

func remove_random_luggage()->Luggage:
  if luggage.get_child_count() == 0:
    return null
  var idx = randi() % luggage.get_child_count()
  var lug:Luggage = luggage.get_child(idx)
  luggage.remove_child(lug)
  return lug

func get_time_remaining()->int:
  return time - Globals.get_time()

func _to_string() -> String:
  var name = Globals.destinations[destination]
  var remain = get_time_remaining()
  var minutes = remain / 60
  var seconds = remain % 60
  return '%s in %d:%02d at Gate %s' % [name, minutes, seconds, dock]

func _process(delta: float) -> void:
  if on_time && get_time_remaining() < 0:
    on_time = false
    Globals.emit_signal('game_over', self)
