extends Node

class_name SCClient

const version = '1.0.0'
	
func create(options):
	print("Create Called")
	
	#check host match
	
	#check isurlsecure
	
	var opts = {
		'clientId': uuid.v4(),
		'version': version,
		#'port': getPort(options, isSecureDefault)
		'hostname': 'localhost',
		#'secure': isSecureDefault
	}
	
	opts = dictionary_utils.merge(opts, options)

	var socket = SCClientSocket.new(opts)
	socket.name = opts['clientId']
	self.add_child(socket)
	return socket

