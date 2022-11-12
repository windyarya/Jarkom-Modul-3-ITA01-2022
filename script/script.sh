#!/bin/bash

Ostania() {
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.40.0.0/16

apt-get update
apt-get install isc-dhcp-relay -y

# no 2
echo "
# What servers should the DHCP relay forward requests to?
SERVERS=\"10.40.2.4\"
# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES=\"eth1 eth2 eth3\"
# Additional options that are passed to the DHCP relay daemon?
OPTIONS=\"\"
" > /etc/default/isc-dhcp-relay

service isc-dhcp-relay start
# echo "Starting DHCP Relay"
}

WISE() {
echo "nameserver 192.168.122.1" > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

# no 5
echo "
options {
        directory \"/var/cache/bind\";

        forwarders {
                192.168.122.1;
        };

        allow-query { any; };
        auth-nxdomain no;
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options

service bind9 restart
}

Berlint() {
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install squid -y

# no 8 - selesai
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo "
loid-work.com
franky-work.com
" > /etc/squid/work-sites.acl

echo "
acl AVAILABLE_WORKING time MTWHF 08:00-16:59
acl AVAILABLE_INTERNET time MTWHF 17:00-23:59
acl AVAILABLE_INTERNET time MTWHF 00:00-08:00
acl AVAILABLE_INTERNET time SA 00:00-23:59
" > /etc/squid/acl.conf

echo "
include /etc/squid/acl.conf

http_port 8080
visible_hostname Berlint

acl SSL_ports port 443
acl WORKSITES dstdomain "/etc/squid/work-sites.acl"

# commant deny !SSL_ports jika ingin speedtest
http_access deny !SSL_ports
http_access allow WORKSITES AVAILABLE_WORKING
http_access deny WORKSITES AVAILABLE_INTERNET
http_access allow AVAILABLE_INTERNET
http_access deny AVAILABLE_WORKING
http_access deny all

acl NOT_LIMIT time MTWHF
delay_pools 1
delay_class 1 2
delay_access 1 allow !NOT_LIMIT
delay_parameters 1 none 16000/16000
" > /etc/squid/squid.conf

service squid restart
}

Westalis() {
echo "nameserver 192.168.122.1" > /etc/resolv.conf

apt-get update
apt-get install isc-dhcp-server -y

echo "
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server

# no 3 dan 4
echo "
# no 3
subnet 10.40.1.0 netmask 255.255.255.0 {
        range 10.40.1.50 10.40.1.88;
        range 10.40.1.120 10.40.1.155;
        option routers 10.40.1.1;
        option broadcast-address 10.40.1.255;
        option domain-name-servers 10.40.2.2;
        #no 6        
        default-lease-time 300;
        max-lease-time 6900;
}

subnet 10.40.2.0 netmask 255.255.255.0 {}

# no 4
subnet 10.40.3.0 netmask 255.255.255.0 {
        range 10.40.3.10 10.40.3.30;
        range 10.40.3.60 10.40.3.85;
        option routers 10.40.3.1;
        option broadcast-address 10.40.3.255;
        option domain-name-servers 10.40.2.2;
        # no 6
        default-lease-time 600;
        max-lease-time 6900;
}
# no 7
host Eden {
        hardware ethernet 7a:68:b2:d1:13:73;
        fixed-address 10.40.3.13;
}
" > /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
}

SSS() {
export http_proxy="http://10.40.2.3:8080"

apt-get update
apt-get install lynx -y
apt-get install speedtest-cli -y
}

Garden() {
export http_proxy="http://10.40.2.3:8080"

apt-get update
apt-get install lynx -y
apt-get install speedtest-cli -y
}

Eden() {
export http_proxy="http://10.40.2.3:8080"

apt-get update
apt-get install lynx -y
apt-get install speedtest-cli -y
}

NewstonCastle() {
apt-get update
apt-get install lynx -y
apt-get install speedtest-cli -y
}

KemonoPark() {
apt-get update
apt-get install lynx -y
apt-get install speedtest-cli -y
}