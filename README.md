# WSL2-kind-crpd

## WSL2 installation

Before starting, make sure you have the latest version of WSL2 installed. WSL2 is not enabled by default on windows, so you need to turn it on in the following menu: "Control Pannel -> Programs and Features -> Turn windows features on or off".

<img width="557" alt="image" src="https://user-images.githubusercontent.com/21667569/206169945-6951d695-4fe0-4ac9-a689-5c9f7a3bb667.png">

Then check both "Windows Subsystem for Linux" and "Virtual Machine Platform".

<img width="346" alt="image" src="https://user-images.githubusercontent.com/21667569/206170202-e577bc12-38e8-4d93-a399-4a0623cd23f3.png">

If you're in recent windows, you should have ubuntu 20.04 running (which is the assumption for the following).

In powershell, just execute the wsl command.
```(console)
PS C:\Users\rroberts> wsl
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@rroberts-P50:/mnt/c/Users/rroberts$ cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
ubuntu@rroberts-P50:/mnt/c/Users/rroberts$
```
If you have an older Windows install, you can easily upgrade your installation via powershell in administrator mode.

```(console)
PS C:\WINDOWS\system32> wsl -l -v
  NAME      STATE           VERSION
* Legacy    Running         1

PS C:\WINDOWS\system32> wsl --update
Checking for updates...
Downloading updates...
Installing updates...
This change will take effect on the next full restart of WSL. To force a restart, please run 'wsl --shutdown'.
Kernel version: 5.10.102.1
PS C:\WINDOWS\system32> wsl --shutdown
PS C:\WINDOWS\system32> wsl --list --online
The following is a list of valid distributions that can be installed.
Install using 'wsl --install -d <Distro>'.

NAME            FRIENDLY NAME
Ubuntu          Ubuntu
Debian          Debian GNU/Linux
kali-linux      Kali Linux Rolling
openSUSE-42     openSUSE Leap 42
SLES-12         SUSE Linux Enterprise Server v12
Ubuntu-16.04    Ubuntu 16.04 LTS
Ubuntu-18.04    Ubuntu 18.04 LTS
Ubuntu-20.04    Ubuntu 20.04 LTS

PS C:\WINDOWS\system32> wsl --install -d  Ubuntu-20.04
Downloading: Ubuntu 20.04 LTS
Installing: Ubuntu 20.04 LTS
Ubuntu 20.04 LTS has been installed.
Launching Ubuntu 20.04 LTS...
```

## Kubectl, Docker and Kind installation

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

```
ubuntu@rroberts-T14:~/WSL/WSL2-kind-crpd/code$ docker image list
REPOSITORY     TAG         IMAGE ID       CREATED         SIZE
ubuntu         latest      a8780b506fa4   5 weeks ago     77.8MB
kindest/node   <none>      d8644f660df0   6 weeks ago     898MB
crpd           22.3R1.11   5dfdda6ea2de   2 months ago    461MB
hello-world    latest      feb5d9fea6a5   14 months ago   13.3kB
kindest/node   <none>      32b8b755dee8   18 months ago   1.12GB
kindest/node   v1.20.0     ad1bcd4daa66   24 months ago   1.33GB
ubuntu@rroberts-T14:~/WSL/WSL2-kind-crpd/code$ kind load docker-image crpd:22.3R1.11 
```
