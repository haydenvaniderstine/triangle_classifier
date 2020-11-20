extends Node
var client
var client_listener
var s = 1 # 0 means None, 1 means Equilateral, 2 means Isosceles, 3 means Scalene
const off_material = preload("res://off_material.tres")
const on_material = preload("res://on_material.tres")

func _ready():
	client = PacketPeerUDP.new()
	client.connect_to_host("192.168.0.16",12000)
	
	get_node("Button").connect("button_down", self, "_button_pressed")
	
	client_listener = PacketPeerUDP.new()
	client_listener.listen(12001,"*")
	
func _process(delta):
	if client_listener.get_available_packet_count() > 0:
		var solution = int(Array(client_listener.get_packet())[0])
		print("client received solution " + str(solution))
		_process_solution_data(solution)

func _button_pressed():
	print("BUTTON PRESSED!!!")
	get_node("Button").text = "SOLVING..."
	var angle_one = int(get_node("LineEdit").text)
	var angle_two = int(get_node("LineEdit2").text)
	var angle_three = int(get_node("LineEdit3").text)
	client.put_packet(PoolByteArray([angle_one, angle_two, angle_three]))

func _process_solution_data(i):
	get_node("Button").text = "SOLVE"
	for k in range(4):
		if i == k:
			if s != k:
				get_node("MeshInstance" + str(s)).mesh.surface_set_material(0,off_material)
				get_node("MeshInstance" + str(i)).mesh.surface_set_material(0,on_material)
	# SET NEW s VALUE TO BE THE GIVEN SOLUTION VALUE (0, 1, 2, or 3)
	s = i
