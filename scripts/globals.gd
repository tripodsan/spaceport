extends Node

var game_start_time:int

var game_pause_time:int

var beginning_of_time = Time.get_unix_time_from_datetime_string('2034-04-01T08:00:00Z')

var started:bool = false

var paused:bool = true

# warning-ignore:unused_signal
signal game_pause_changed(paused)

signal game_over(flight)

signal reset()

var destinations:Dictionary = {
  'MON': 'Moon',
  'EUR': 'Europa',
  'TER': 'Earth',
  'KEP': 'Keppler',
  'MRS': 'Mars',
  'VES': 'Venus',
}

var docks = ['A', 'B', 'C', 'D', 'E', 'F', 'G']

func get_time()->int:
  # warning-ignore:integer_division
  return (Time.get_ticks_msec() - game_start_time) / 1000

func get_wall_time()->int:
  return get_time() + beginning_of_time

func start():
  if started:
    return
  paused = false
  started = true
  game_start_time = Time.get_ticks_msec()
  game_pause_time = 0

func stop():
  if started:
    started = false
    paused = true

func pause(value:bool):
  if !started:
    return
  if paused != value:
    paused = value
    if paused:
      game_pause_time = Time.get_ticks_msec()
    else:
      game_start_time += Time.get_ticks_msec() - game_pause_time
    emit_signal('on_game_pause_changed', paused)
