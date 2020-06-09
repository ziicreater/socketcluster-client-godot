extends Node

class_name dictionary_utils

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

static func exists(key, source):
	if source.has(key) && typeof(source) == TYPE_DICTIONARY:
		return source[key]
	else:
		return null
