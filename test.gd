extends Node

var clientsocket:SCClientSocket

func _ready():
	var client = SCClient.new()
	client.name = "SCClient"
	self.add_child(client)
	clientsocket = client.create({'path': '/newpath/', 'autoConnect': false})
	clientsocket.connect("connecting", self, "testfunc")

func testfunc():
	print("socket is connecting")

func _on_Button_pressed():
	clientsocket.socketconnect()
