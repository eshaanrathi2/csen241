CSEN 241, Winter 2024
HW 3

Submitted by: Eshaan Rathi
Link to Code: https://github.com/eshaanrathi2/csen241/tree/main/hw3


Task 1

Q 1. What is the output of “nodes” and “net”
mininet> nodes
available nodes are: 
c0 h1 h2 h3 h4 h5 h6 h7 h8 s1 s2 s3 s4 s5 s6 s7

mininet> net
h1 h1-eth0:s3-eth1
h2 h2-eth0:s3-eth2
h3 h3-eth0:s4-eth1
h4 h4-eth0:s4-eth2
h5 h5-eth0:s6-eth1
h6 h6-eth0:s6-eth2
h7 h7-eth0:s7-eth1
h8 h8-eth0:s7-eth2
s1 lo:  s1-eth1:s2-eth3 s1-eth2:s5-eth3
s2 lo:  s2-eth1:s3-eth3 s2-eth2:s4-eth3 s2-eth3:s1-eth1
s3 lo:  s3-eth1:h1-eth0 s3-eth2:h2-eth0 s3-eth3:s2-eth1
s4 lo:  s4-eth1:h3-eth0 s4-eth2:h4-eth0 s4-eth3:s2-eth2
s5 lo:  s5-eth1:s6-eth3 s5-eth2:s7-eth3 s5-eth3:s1-eth2
s6 lo:  s6-eth1:h5-eth0 s6-eth2:h6-eth0 s6-eth3:s5-eth1
s7 lo:  s7-eth1:h7-eth0 s7-eth2:h8-eth0 s7-eth3:s5-eth2
c0

Q 2. What is the output of “h7 ifconfig"
mininet> h7 ifconfig
h7-eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.7  netmask 255.0.0.0  broadcast 10.255.255.255
        inet6 fe80::80b7:1bff:feb5:ca13  prefixlen 64  scopeid 0x20<link>
        ether 82:b7:1b:b5:ca:13  txqueuelen 1000  (Ethernet)
        RX packets 19897  bytes 20122145 (20.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 14  bytes 1076 (1.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


------------------------------------------------------------------------------------------------------------------------


Task 2

Q1.
Switch is started by the start_switch() function. Then the following functions should be called in this order:

_handle_PacketIn ():  Handles packet in messages from the switch.

    |
    V

act_like_switch (): Implement switch-like behavior.

    |
    V

resend_packet ():   Instructs the switch to resend a packet that it had sent.

Alternatively, it can call act_like_switch() instead of act_like_switch() in between.

Q2.

a.
Average Round trip time h1 to h2: 6.620 ms
Average Round trip time h1 to h8: 20.255 ms

b.
Min Round trip time h1 to h2: 1.647 ms
Min Round trip time h1 to h8: 9.143 ms

Max Round trip time h1 to h2: 29.490 ms
Max Round trip time h1 to h8: 37.937ms


c.
h1 and h2 are 2 links away with 1 switch in between.
But h1 and h8 are 6 links away with 5 switches in between.
Higher the separation, higher the ping time.



Q3.

a.
Iperf measures throughput of a network.

b.
mininet> iperf h1 h2
*** Iperf: testing TCP bandwidth between h1 and h2 
*** Results: ['19.7 Mbits/sec', '20.5 Mbits/sec']

mininet> iperf h1 h8
*** Iperf: testing TCP bandwidth between h1 and h8 
*** Results: ['7.40 Mbits/sec', '8.10 Mbits/sec']


c.
Similar reasons as Q 2. More links brings more congestion and higher latency. Hence reduced throughput.

Q 4.
Since the network was already flooded with packets with the command:

./pox.py log.level --DEBUG misc.of_tutorial

all of the switches will have traffic. We can measure it by adding log or print statements in of_totorial.py controller file.

------------------------------------------------------------------------------------------------------------------------

Task 3

Q1.
The refactored code implements the basic functionality of a learning switch, which dynamically learns the mapping between 
MAC addresses and switch ports and makes forwarding decisions based on that information.

   # Learn the port for the source MAC
   # print("Src: ",str(packet.src),":", packet_in.in_port,"Dst:", str(packet.dst))
   if packet.src not in self.mac_to_port:
       print("Learning that " + str(packet.src) + " is attached at port " + str(packet_in.in_port))
       self.mac_to_port[packet.src] = packet_in.in_port
   # if the port associated with the destination MAC of the packet is known:
   if packet.dst in self.mac_to_port:
       # Send packet out the associated port
       print(str(packet.dst) + " destination known. only send message to it")
       self.resend_packet(packet_in, self.mac_to_port[packet.dst])
   else:
       # Flood the packet out everything but the input port
       # This part looks familiar, right?
       print(str(packet.dst) + " not known, resend to everybody")
       self.resend_packet(packet_in, of.OFPP_ALL)


Q2.
a.
Average Round trip time h1 to h2: 5.058 ms
Average Round trip time h1 to h8: 17.257 ms

b.
Min Round trip time h1 to h2: 1.430 ms
Min Round trip time h1 to h8: 5.079 ms

Max Round trip time h1 to h2: 10.917 ms
Max Round trip time h1 to h8: 59.692ms

c.
Yes, Round trip time has reduced by 15 - 20% (average RTT) for both cases h1->h2 and h1->h8.
Previously the switches couldn’t really do much but flood the packets they receive. But now, switches 
will learn the ports packets arrive from, and upon receiving a packet, if they have already seen 
its destination address, they will know the exact port to forward it on and avoid flooding the network (i.e., MAC learning).

Q 3.


a.
mininet> iperf h1 h2
*** Iperf: testing TCP bandwidth between h1 and h2 
*** Results: ['19.9 Mbits/sec', '20.9 Mbits/sec']

mininet> iperf h1 h8
*** Iperf: testing TCP bandwidth between h1 and h8 
*** Results: ['7.93 Mbits/sec', '8.72 Mbits/sec']

b.
Throughput has increased by ~ 0.3 Mbits/sec for h1->h2 and increased by ~ 0.5 Mbits/sec for h1->h8.
The new switching logic has improved the throughput significantly. This is due to maintaining the mac_to_port map, 
which reduced packet flooding and reduced latency / network congestion. 
Hence increasing overall throughput.