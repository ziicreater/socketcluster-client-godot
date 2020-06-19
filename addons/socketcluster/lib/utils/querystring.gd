extends Node

class_name querystring

static func encode(obj, sep = '&', eq = '=', name = '') -> String :
	var query = ''
	if typeof(obj) == TYPE_DICTIONARY:
		for key in obj:
			if typeof(obj[key]) == TYPE_DICTIONARY:
				query = query + encode(obj[key]) + sep
			else:
				query = query + key + eq + obj[key] + sep
	query.erase(query.length() - 1, 1)
	return query

static func decode(qs, sep = '&', eq = '=', options = {}) -> Dictionary :
	var obj = {}
	
	if typeof(qs) != TYPE_STRING && qs.length == 0:
		return obj
	
	var regex = RegEx.new()
	regex.compile("\\s+")
	qs = qs.split(sep)
	
	var maxKeys = 1000
	if options != {} && options.has('maxKeys') && options['maxKeys'] == TYPE_INT:
		maxKeys = options['maxKeys']
	
	var le = qs.size()
	if maxKeys > 0 && le > maxKeys:
		le = maxKeys
	
	for i in range(0, le):
		var x = regex.sub(qs[i], '+', true)
		var idx = x.split(eq)
		var kstr
		var vstr
		
		if idx.size() >= 0:
			kstr = idx[0]
			vstr = idx[1]
		else:
			kstr = idx[0]
			vstr = ''
		
		obj[kstr] = vstr
		
	return obj
	
	
	
	
	
