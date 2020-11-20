extends Node
var server
var server_solution_sender
var not_yet_connected = true

func _ready():	
	get_tree().connect("network_peer_connected", self, "_on_connection")	
	get_tree().connect("network_peer_disconnected", self, "_on_disconnection")	
	server = PacketPeerUDP.new()	
	server.listen(12000, '*')
	
	server_solution_sender = PacketPeerUDP.new()
	
func _process(delta):	
	if server.get_available_packet_count() > 0:
		if not_yet_connected:
			server_solution_sender.connect_to_host("192.168.0.16",12001)
			not_yet_connected = false
		
		var angles_array = Array(server.get_packet())
		print("Server received: " + str(angles_array))
		var a = angles_array[0]
		var b = angles_array[1]
		var c = angles_array[2]
		var solution = _solve(a,b,c)
		print(solution)
		server_solution_sender.put_packet(PoolByteArray([solution]))
func _on_connection(id):
	print("Server received connection")	
func _on_disconnection(id):	
	print("Server received disconnection")

func _solve(a,b,c):
	if a+b+c != 180:
		return 0 # not a triangle
	elif a == b:
		if a == c:
			return 1 # equilateral
		else:
			return 2 # isosceles
	elif a == c:
		return 2 # isosceles
	elif b == c:
		return 2 # isosceles
	else:
		return 3 # scalene
