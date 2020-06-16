extends Node

class_name querystring

static func encode(obj, sep = '&', eq = '=', name = ''):
	var query = ''
	if typeof(obj) == TYPE_DICTIONARY:
		for key in obj:
			if typeof(obj[key]) == TYPE_DICTIONARY:
				query = query + encode(obj[key]) + sep
			else:
				query = query + key + eq + obj[key] + sep
	query.erase(query.length() - 1, 1)
	return query
