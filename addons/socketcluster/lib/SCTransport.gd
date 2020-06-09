extends Node

class_name SCTransport

signal onOpen(value)
signal onOpenAbort(value)
signal onClose(value)
signal onEvent(value)
signal onError(value)
signal onInboundInvoke(value)
signal onInboundTransmit(value)

enum ESocketState {
	CLOSED,
	CONNECTING,
	OPEN,
}

var state
var auth:SCAuthEngine
var codec:SCCodecEngine
var options
var wsOptions
var protocolVersion
var connectTimeout
var pingTimeout
var pingTimeoutDisabled
var callIdGenerator
var authTokenName
var isBufferingBatch
var _pingTimeoutTicker
var _callbackMap
var _batchBuffer
var socket

func _init(authEngine, codecEngine, options, wsOptions):
	state = ESocketState.CLOSED
	auth = authEngine
	codec = codecEngine
	options = options
	wsOptions = wsOptions
	protocolVersion = options['protocolVersion']
	connectTimeout = options['connectTimeout']
	pingTimeout = options['pingTimeout']
	pingTimeoutDisabled = options['pingTimeoutDisabled']
	callIdGenerator = options['callIdGenerator']
	authTokenName = options['authTokenName']
	isBufferingBatch = false
	
	_pingTimeoutTicker = null
	_callbackMap = {}
	_batchBuffer = []
	
	state = ESocketState.CONNECTING
	var uri = uri()
	
	var wsSocket = WebSocketClient.new()
	var supported_protocols = PoolStringArray(["socketcluster"])
	var protocols = wsOptions['protocols'] if wsOptions.has('protocols') else PoolStringArray(["socketcluster"])
	wsSocket.connect_to_url(uri, protocols, false)
	
	socket = wsSocket
	
	wsSocket.connect("connection_established", self, "_onOpen")
	wsSocket.connect("connection_closed", self, "_onClose")
	wsSocket.connect("data_received", self, "_onMessage")
	wsSocket.connect("connection_error", self, "_onError")
	wsSocket.connect("server_close_request", self, "_onServerClose")
	wsSocket.connect("server_disconnected", self, "_onClose")

func uri():
	var query = options['query'] if options.has('query') else {}
	var scheme
	if !options.has('protocolScheme'):
		scheme = 'wss' if options.has('secure') && options['secure'] == true else 'ws'
	else:
		scheme = options['protocolScheme']
	
	if options['timestampRequests'] == true:
		query[options['timestampParam']] = OS.get_unix_time()
	
	query = querystring.encode(query)
			
	pass
	
func _onOpen(protocol):
	#cleartimeout
	#resetPingtimeout
	_handshake()
	print("Websocket connected with protocol: %s" % protocol)

func _onClose(clean=true):
	print("Websocket closed")

func _onServerClose(code, reason):
	print(str(code) + " " + str(reason))

func _onMessage():
	var data = socket.get_peer(1).get_packet()
	print("Message : %s" % data.get_string_from_utf8())

func _onError():
	print("Error Received")

func _handshake():
	#load authtoken
	#options force
	var data = {"event":"#handshake","data":{"authToken":null},"cid":1}
	var data_send = JSON.print(data)
	print(data_send)
	socket.get_peer(1).put_packet(data_send.to_utf8())
	
func _process(_delta):
	socket.poll()
	
