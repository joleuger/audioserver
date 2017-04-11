The easiest way (IMHO) to give the systemd/nspawn container an own IP in the home network of the user, is to connect the container to a (software) bridge.
For that, the user has to create such a bridge and connect the main network device to this bridge.
For more details see
   https://wiki.archlinux.org/index.php/Network_bridge
and
   https://wiki.debian.org/BridgeNetworkConnections.

Note, that the main network device may loose its IP when it is connected to a bridge. No guarantuees. Use these hints on your own risk.

In my case, I had to change /etc/network/interfaces on the host like this. This is individual on every server.

```
auto br_wired

auto p12p4

iface p12p4 inet manual

iface br_wired inet static
        bridge_ports p12p4
                address 192.168.0.2
                netmask 255.255.255.0
                gateway 192.168.0.1
                dns-nameservers 192.168.0.1 8.8.8.8
```

When you are connected to the server remotely, it is best to do something like this:

```
screen
cd /etc/network
cp interfaces interfaces_working
# now change interfaces
# now we need to apply the new configuration. When the connection drops, the network gets restarted automatically. If the connection still works, the user can cancel 'sleep 60' with CTRL+C. Note, no guarantee that this works.
/etc/init.d/networking restart && sleep 60 && cp interfaces_working interfaces && /etc/init.d/networking restart
```

Now the software bridge br_wired is connected to my home network. Connecting a systemd/nspawn container to my home network is now as simple as `systemd-nspawn ... --network-bridge=br_wired`.
For more details, consult `man systemd-nspawn`.

