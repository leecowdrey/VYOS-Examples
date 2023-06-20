firewall {
    all-ping enable
    broadcast-ping disable
    config-trap disable
    group {
        address-group DNS-CHILDREN {
            address 185.228.168.168
            address 185.228.169.168
        }
        address-group DNS-GENERAL {
            address 208.67.222.222
            address 208.67.222.220
            address 208.67.220.220
        }
        address-group DNS-GOOGLE {
            address 8.8.8.8
            address 8.8.4.4
        }
        ipv6-address-group DNS-CHILDREN6 {
            address 2a0d:2a00:1::
            address 2a0d:2a00:2::
        }
        ipv6-address-group DNS-GENERAL6 {
            address 2620:119:35::35
            address 2620:119:53::53
        }
        ipv6-address-group DNS-GOOGLE6 {
            address 2001:4860:4860::8888
            address 2001:4860:4860::8844
        }
        network-group NET-CHILDREN {
            network 192.168.10.0/24
        }
        network-group NET-GENERAL {
            network 192.168.30.0/24
        }
        port-group DOH {
            description DNS-over-HTTP/TLS
            port 853
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name OUTSIDE-IN {
        default-action drop
        rule 10 {
            action drop
            protocol all
            source {
                group {
                    address-group DNS-GOOGLE
                }
            }
        }
        rule 20 {
            action accept
            state {
                established enable
                related enable
            }
        }
    }
    name OUTSIDE-LOCAL {
        default-action drop
        rule 10 {
            action accept
            destination {
                address 224.0.0.251
                port 5353
            }
            protocol udp
            source {
                group {
                    network-group NET-GENERAL
                }
            }
        }
        rule 20 {
            action drop
            state {
                invalid enable
            }
        }
        rule 30 {
            action accept
            icmp {
                type-name echo-request
            }
            protocol icmp
            state {
                new enable
            }
        }
        rule 40 {
            action accept
            destination {
                group {
                    address-group DNS-CHILDREN
                }
                port 53
            }
            protocol udp
            source {
                group {
                    network-group NET-CHILDREN
                }
            }
        }
        rule 42 {
            action accept
            destination {
                group {
                    address-group DNS-GENERAL
                }
                port 53
            }
            protocol udp
        }
        rule 50 {
            action drop
            destination {
                port 53
            }
            protocol tcp_udp
        }
        rule 60 {
            action accept
            destination {
                port 67-68
            }
            protocol udp
        }
        rule 70 {
            action accept
            destination {
                port 123
            }
            protocol udp
        }
        rule 80 {
            action accept
            protocol vrrp
        }
        rule 90 {
            action accept
            destination {
                port 647
            }
            protocol tcp
        }
        rule 100 {
            action drop
            destination {
                port 22
            }
            protocol tcp
            recent {
                count 4
                time 60
            }
            state {
                new enable
            }
        }
        rule 110 {
            action accept
            destination {
                port 22
            }
            protocol tcp
            state {
                new enable
            }
        }
        rule 120 {
            action drop
            destination {
                group {
                    port-group DOH
                }
            }
            protocol tcp
        }
        rule 130 {
            action drop
            destination {
                group {
                    address-group DNS-GOOGLE
                }
            }
            protocol all
        }
        rule 990 {
            action accept
            state {
                established enable
                related enable
            }
        }
    }
    options {
        interface pppoe0 {
            adjust-mss 1452
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    state-policy {
        established {
            action accept
        }
        invalid {
            action drop
        }
        related {
            action accept
        }
    }
    syn-cookies enable
    twa-hazards-protection disable
}
interfaces {
    bridge br0 {
        address 192.168.30.1/24
        aging 300
        description GENERAL
        hello-time 2
        max-age 20
        member {
            interface eth1 {
            }
            interface eth2 {
            }
            interface eth3 {
            }
        }
        priority 32768
        stp
    }
    ethernet eth0 {
        description PHY-WAN
        duplex auto
        firewall {
            in {
                name OUTSIDE-IN
            }
            local {
                name OUTSIDE-LOCAL
            }
        }
        hw-id 00:e0:67:21:74:e4
        ipv6 {
            disable-forwarding
            dup-addr-detect-transmits 1
        }
        offload {
            gro
            gso
            sg
            tso
        }
        policy {
            route MSS
        }
        speed auto
    }
    ethernet eth1 {
        description PHY-LAN
        duplex full
        hw-id 00:e0:67:21:74:e5
        ipv6 {
            disable-forwarding
            dup-addr-detect-transmits 1
        }
        offload {
            gro
            gso
            sg
            tso
        }
        speed 1000
    }
    ethernet eth2 {
        description PHY-OPT1
        duplex full
        hw-id 00:e0:67:21:74:e6
        ipv6 {
            disable-forwarding
            dup-addr-detect-transmits 1
        }
        offload {
            gro
            gso
            sg
            tso
        }
        speed 1000
    }
    ethernet eth3 {
        description PHY-OPT2
        duplex full
        hw-id 00:e0:67:21:74:e7
        ipv6 {
            disable-forwarding
            dup-addr-detect-transmits 1
        }
        offload {
            gro
            gso
            sg
            tso
        }
        speed 1000
    }
    pppoe pppoe0 {
        authentication {
            password SPE3CIALPA33W0RD
            user ISPUSERID
        }
        default-route auto
        idle-timeout 0
        mtu 1492
        no-peer-dns
        source-interface eth0
    }
    wireless wlan0 {
        address dhcp
        mode n
        security {
            cipher CCMP
            mode wpa2
            wpa {
                passphrase "c3r3brus"
            }
        }
        ssid ICHI
        type station
    }
}
nat {
    source {
        rule 30 {
            outbound-interface eth0
            source {
                address 192.168.30.0/24
            }
            translation {
                address masquerade
            }
        }
    }
}
policy {
    route MSS {
        description "TCP MSS clamping for PPPoE"
        rule 5 {
            protocol tcp
            set {
                tcp-mss 1452
            }
            tcp {
                flags SYN
            }
        }
    }
}
service {
    dhcp-server {
        hostfile-update
        shared-network-name GENERAL {
            authoritative
            description GENERAL
            subnet 192.168.30.0/24 {
                client-prefix-length 24
                default-router 192.168.30.1
                domain-name 30.local
                lease 3600
                name-server 208.67.220.220
                name-server 208.67.222.222
                name-server 208.67.222.220
                ntp-server 192.168.30.1
                range 0 {
                    start 192.168.30.20
                    stop 192.168.30.239
                }
                static-mapping hp-ep6430 {
                    ip-address 192.168.30.10
                    mac-address 6c:02:e0:9f:66:e6
                }
                static-mapping icx6450 {
                    ip-address 192.168.30.254
                    mac-address cc:4e:24:00:00:00
                }
            }
        }
    }
    ssh {
        client-keepalive-interval 60
        disable-host-validation
        disable-password-authentication
        listen-address 192.168.30.1
        port 22
    }
    tftp-server {
        allow-upload
        directory /config/tftpboot
        listen-address 192.168.30.1 {
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    conntrack {
        expect-table-size 2048
        hash-size 32768
        modules {
            ftp
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
        table-size 262144
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    domain-name 0.local
    host-name ichi
    ipv6 {
        disable
        disable-forwarding
        strict-dad
    }
    name-server 208.67.220.220
    name-server 208.67.222.222
    name-server 208.67.222.220
    ntp {
        allow-clients {
            address 192.168.30.0/24
        }
        listen-address 192.168.30.1
        server 217.116.122.136 {
            prefer
        }
        server 217.116.122.137 {
        }
    }
    option {
        ctrl-alt-delete ignore
        reboot-on-panic
        startup-beep
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    task-scheduler {
        task CHILDREN-DOWN {
            crontab-spec "30 19 * * *"
            executable {
                path /config/scripts/ChildrenDown
            }
        }
        task CHILDREN-UP {
            crontab-spec "30 07 * * *"
            executable {
                path /config/scripts/ChildrenUp
            }
        }
    }
    time-zone Europe/London
}


// Warning: Do not remove the following line.
// vyos-config-version: "broadcast-relay@1:cluster@1:config-management@1:conntrack@3:conntrack-sync@2:dhcp-relay@2:dhcp-server@6:dhcpv6-server@1:dns-forwarding@3:firewall@5:https@2:interfaces@22:ipoe-server@1:ipsec@5:isis@1:l2tp@3:lldp@1:mdns@1:nat@5:ntp@1:pppoe-server@5:pptp@2:qos@1:quagga@8:rpki@1:salt@1:snmp@2:ssh@2:sstp@3:system@21:vrrp@2:vyos-accel-ppp@2:wanloadbalance@3:webproxy@2:zone-policy@1"
// Release version: 1.3.1-S1
