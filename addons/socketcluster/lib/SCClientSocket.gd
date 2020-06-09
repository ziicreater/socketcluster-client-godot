extends Node

class_name SCClientSocket

signal connecting

enum ESocketClusterState {
	CLOSED,
	CONNECTING,
	OPEN,
}

enum ESocketClusterAuthState {
	AUTHENTICATED,
	UNAUTHENTICATED,
}

var clientId
var id
var state
var authState
var signedAuthToken
var authToken
var authTokenName
var pendingReconnect
var pendingReconnectTimeout
var preparingPendingSubscriptions
var connectTimeout
var ackTimeout
var channelPrefix
var pingTimeout
var pingTimeoutDisabled
var connectAttempts
var channels = {}
var version
var _cid
var options
var autoReconnectOptions
var auth
var codec
var transport:SCTransport
var wsOptions

func _init(socketOptions):
	
	var defaultOptions = {
		'path': '/socketcluster/',
		'secure': false,
		'protocolScheme': null,
		'socketPath': null,
		'autoConnect': true,
		'autoReconnect': true,
		'autoSubscribeOnConnect': true,
		'connectTimeout': 20000,
		'ackTimeout': 10000,
		'timestampRequests': false,
		'timestampParam': 't',
		'authTokenName': 'socketcluster.authToken',
		'binaryType': 'arraybuffer',
		'batchOnHandshake': false,
		'batchOnHandshakeDuration': 100,
		'batchInterval': 50,
		'protocolVersion': 2,
		'wsOptions': {},
		'cloneData': false
	}

	var opts = dictionary_utils.merge(defaultOptions, socketOptions)
	
	id = null
	version = dictionary_utils.exists('version', opts)
	var protocolVersion = opts['protocolVersion']
	state = ESocketClusterState.CLOSED
	authState = ESocketClusterAuthState.UNAUTHENTICATED
	signedAuthToken = null
	authToken = null
	pendingReconnect = false
	pendingReconnectTimeout = null
	preparingPendingSubscriptions = false
	clientId = opts['clientId']
	wsOptions = opts['wsOptions']
	connectTimeout = opts['connectTimeout']
	ackTimeout = opts['ackTimeout']
	channelPrefix = dictionary_utils.exists('channelPrefix', opts)
	
	opts['pingTimeout'] = opts['connectTimeout']
	pingTimeout = opts['pingTimeout']
	#pingTimeoutDisabled = !!opts['pingTimeoutDisabled']
	
	var maxTimeout = pow(2, 31) -1
	
	verifyDuration('connectTimeout', maxTimeout)
	verifyDuration('ackTimeout', maxTimeout)
	verifyDuration('pingTimeout', maxTimeout)
	
	connectAttempts = 0
	
	#_channelMap = {}
	
	options = opts
	
	_cid = 0
	
	if options['autoReconnect'] == true:
		if dictionary_utils.exists('autoReconnectOptions', options) == null:
			options['autoReconnectOptions'] = {}
		
		var reconnectOptions = options['autoReconnectOptions']
		if dictionary_utils.exists('initialDelay', reconnectOptions) == null:
			reconnectOptions['initialDelay'] = 10000
		
		if dictionary_utils.exists('randomness', reconnectOptions) == null:
			reconnectOptions['randomness'] = 10000
		
		if dictionary_utils.exists('multiplier', reconnectOptions) == null:
			reconnectOptions['multiplier'] = 1.5
		
		if dictionary_utils.exists('maxDelay', reconnectOptions) == null:
			reconnectOptions['maxDelay'] = 60000
	
	#if dictionary_utils.exists('authEngine', options) != null:
	#	auth = options['authEngine']
	#else:
	#	auth = default auth engine
	
	#if dictionary_utils.exists('codecEngine', options) != null:
	#	codec = options['codecEngine']
	#else:
	#	codec = default codec engine
	
	if dictionary_utils.exists('query', opts) != null:
		options['query'] = opts['query']
	else:
		options['query'] = {}
	
	if typeof(options['query']) == TYPE_STRING:
		options['query'] = querystringparse(options['query'])
	
	if options['autoConnect']:
		socketconnect()

func querystringparse(query):
	pass
	
func callIdGenerator():
	return ++_cid

func socketconnect():
	
	if state == ESocketClusterState.CLOSED:
		pendingReconnect = false
		pendingReconnectTimeout = null
		#cleartimer
		
		state = ESocketClusterState.CONNECTING
		emit_signal("connecting")
		
		if transport:
			transport.clearAllListeners()
		
		transport = SCTransport.new(auth, codec, options, wsOptions)
		transport.name = "SCTransport"
		self.add_child(transport)
		
		transport.connect("onOpen", self, "_onOpen")
		
		
	print('connect called')

func _onOpen(value):
	state = ESocketClusterState.OPEN
	print("Message OnOpen Called")

func verifyDuration(propertyName, time):
	if get(propertyName) > time:
		print('The %s value provided exceeded the maximum amount allowed' % propertyName)
