# WSL2-kind-crpd

readme
```
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

```
ubuntu@rroberts-T14:~/WSL/CRPD$ docker image ls crpd*
REPOSITORY   TAG         IMAGE ID       CREATED        SIZE
crpd         22.3R1.11   5dfdda6ea2de   2 months ago   461MB

docker run -it --rm -d --name crpd crpd:22.3R1.11

```
