# !/bin/bash

pid_ue=$(sudo docker inspect -f '{{.State.Pid}}' ue)
pid_dn=$(sudo docker inspect -f '{{.State.Pid}}' dn)


sudo ip link add eth1 type veth peer name veth2
sudo ip link add eth2 type veth peer name veth4
sudo ip link add eth3 type veth peer name amf_veth

sudo ip link set eth1 netns $pid_ue
sudo ip link set eth3 netns $pid_ue
sudo ip link set eth2 netns $pid_dn

sudo ip link set veth2 up
sudo ip link set veth4 up
sudo ip link set amf_veth up
sudo ip addr add 192.169.56.101/16 dev amf_veth


docker exec -it ue ip addr add 198.20.0.2/16 dev eth1
docker exec -it ue ip addr add 192.169.56.102/16 dev eth3
docker exec -it dn ip addr add 198.21.0.2/16 dev eth2

docker exec -it ue ifconfig eth1 hw ether 88:00:66:99:5b:48 
docker exec -it dn ifconfig eth2 hw ether 7c:d3:0a:90:83:c1 
docker exec -it ue ip link set eth1 up
docker exec -it ue ip link set eth3 up
docker exec -it dn ip link set eth2 up
docker exec -it dn ip route add default dev eth2


