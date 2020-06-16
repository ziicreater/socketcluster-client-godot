extends Node

class_name utils

static func merge(target, source):
	for key in source:
		if target.has(key):
			var target_value = target[key]
			var source_value = source[key]
			if typeof(target_value) == TYPE_DICTIONARY:
				if typeof(source_value) == TYPE_DICTIONARY:
					merge(target_value, source_value)
				else:
					target[key] = source_value
			else:
				target[key] = source_value
		else:
			target[key] = source[key]
	return target

static func clearTimeout(timer):
	timer.stop()

static func setTimeout(timer, time, target, callback):
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = time
	timer.one_shot = true
	timer.connect('timeout', target, callback)
	target.add_child(timer)
	return timer
