extends Node2D

class_name Flight

onready var luggage:Node2D = get_node('%luggage')

onready var carts:Node2D = get_node('%carts')

var luggage_set_scenes:Array = [
  preload("res://sprites/luggage_set0.tscn"),
  preload("res://sprites/luggage_set1.tscn"),
  preload("res://sprites/luggage_set2.tscn"),
  preload("res://sprites/luggage_set3.tscn")
]

## time until departue
var time:int

## destination
export var destination:String

## departure dock
export var dock:String

func add_luggage(set_nr:int):
  var set:Node2D = luggage_set_scenes[set_nr].instance()
  for lug in set.get_children():
    set.remove_child(lug)
    luggage.add_child(lug)

func get_luggage_count()->int:
  return luggage.get_child_count()

func remove_random_luggage()->Luggage:
  if luggage.get_child_count() == 0:
    return null
  var idx = randi() % luggage.get_child_count()
  var lug:Luggage = luggage.get_child(idx)
  luggage.remove_child(lug)
  return lug

func _to_string() -> String:
  var name = Globals.destinations[destination]
  var remain = time - Globals.get_time()
  var minutes = remain / 60
  var seconds = remain % 60
  return '%s in %d:%02d at Gate %s' % [name, minutes, seconds, dock]
