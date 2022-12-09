#!/bin/bash
#
# Deploys the IP Fabric
#

LINK_SUBNET=172.30/16

spines=$(kubectl get nodes -o name -l fabric=spine| cut -d/ -f2 | grep worker) 
leaves=$(kubectl get nodes -o name -l fabric=leaf| cut -d/ -f2 | grep worker) 

# Build docker bridges to connect
echo List of spines and list of leaves retrieved from k8s
echo $spines
echo $leaves

subnet_prefix=$(echo $LINK_SUBNET| cut -d/ -f1)

i=0
for leaf in $leaves; do
  for spine in $spines; do
  echo ""
  i=$(expr $i + 1)
  subnet=$subnet_prefix.$i.0/29
  link=link-$i
  echo Creating $link  with IP subnet $subnet
  docker network create $link --subnet $subnet
#  docker network create test --subnet 172.16.0.0/30
  echo Connecting via $link: Leaf $leaf with ip $subnet_prefix.$i.2 and Spine $spine with ip $subnet_prefix.$i.3  
  docker network connect $link $leaf --ip $subnet_prefix.$i.2
  docker network connect $link $spine --ip $subnet_prefix.$i.3
  done
done

