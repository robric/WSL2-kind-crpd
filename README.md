# WSL2-kind-crpd

readme
```console
ubuntu@rroberts-T14:~/WSL/CRPD$ curl -o junos-routing-crpd-amd64-docker-22.3R1.11.tgz
 "https://cdn.juniper.net/software/crpd/22.3R1/junos-routing-crpd-amd64-docker-22.3R1.11.tgz?SM_USER=rroberts&
__gda__=1670061246_22d39e387f16651435b9d8867acf7d5e"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  149M  100  149M    0     0   9.7M      0  0:00:15  0:00:15 --:--:-- 11.6M

ubuntu@rroberts-T14:~/WSL/CRPD$ docker load -i junos-routing-crpd-amd64-docker-22.3R1.11.tgz 
f8ece8aa5bdf: Loading layer  467.8MB/467.8MB
Loaded image: crpd:22.3R1.11
```

You will now have your cRPD image stored in the local docker repo. You can then start the container.

```console
ubuntu@rroberts-T14:~/WSL/CRPD$ docker image ls crpd*
REPOSITORY   TAG         IMAGE ID       CREATED        SIZE
crpd         22.3R1.11   5dfdda6ea2de   2 months ago   461MB

ubuntu@rroberts-T14:~/WSL/CRPD$ docker run -it --rm -d --name crpd crpd:22.3R1.11
194a68e522c28be38d210ed59d3799a31d0c45b084955ec874c36fa805d9ac89

ubuntu@rroberts-T14:~/WSL/CRPD$ docker ps
CONTAINER ID   IMAGE            COMMAND                 CREATED          STATUS          PORTS
                                                         NAMES
194a68e522c2   crpd:22.3R1.11   "/sbin/runit-init.sh"   15 seconds ago   Up 14 seconds   22/tcp, 179/tcp, 830/tcp, 3784/tcp, 4784/tcp, 6784/tcp, 7784/tcp, 50051/tcp   crpd

```

Now you can play with JUNOS.

```
ubuntu@rroberts-T14:~/WSL/CRPD$ docker exec -it 194a68e522c2 cli
root@194a68e522c2> configure 
Entering configuration mode

[edit]
root@194a68e522c2# run show version 
Hostname: 194a68e522c2
Model: cRPD
Junos: 22.3R1.11
cRPD package version : 22.3R1.11 built by builder on 2022-09-21 19:59:15 UTC

[edit]

root@194a68e522c2# set protocols bgp group local neighbor 1.2.3.4 peer-as 1234 ?
Possible completions:
  <[Enter]>            Execute this command
  accept-prefix-sid    Accept prefix sid from E-BGP peers
  accept-remote-nexthop  Allow import policy to specify a non-directly connected next-hop
  add-path-display-ipv4-address  Display add-path path-id in IPv4 address format
  [...]
```
