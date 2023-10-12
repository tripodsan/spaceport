extends Reference

class_name Flight

## time until departue
var time:int

## destination
var destination:String

## departure dock
var dock:String

# warning-ignore:shadowed_variable
func _init(time:int, dest:String, dock:String) -> void:
  self.time = time
  self.destination = dest
  self.dock = dock

func _to_string() -> String:
  var name = Globals.destinations[destination]
  var remain = time - Globals.get_time()
  var minutes = remain / 60
  var seconds = remain % 60
  return '%s in %d:%02d at Gate %s' % [name, minutes, seconds, dock]
