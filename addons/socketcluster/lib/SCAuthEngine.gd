extends Node

class_name SCAuthEngine

var _token : Dictionary

func saveToken(name : String, token : String, options : Dictionary) -> String :
	_token[name] = token
	return _token[name]

func removeToken(name : String) -> String :
	var token : String = loadToken(name)
	_token.erase(name)
	return token
	
func loadToken(name : String) -> String :
	var token : String
	
	if _token.has(name) && _token[name].empty():
		token = _token[name]
	else:
		token = String()
	
	return token
	
	
