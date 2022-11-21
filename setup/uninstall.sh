
#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

message "Loading environment variables"
 . "$REPO_ROOT"/setup/.env

uninstallFlux() {
    message "removing rook-ceph"
    flux uninstall "$ROOK_NAMESPACE" -s
    message "removing flux-system"
    flux uninstall flux-system -s
}

removek3s(){
    if [ -z "$NODE_USER" ]; then
        echo "NODE_USER is not set! Check $REPO_ROOT/setup/.env"
        exit 1
    fi
    ssh $NODE_USER@$CLUSTER_MASTER /usr/local/bin/k3s-uninstall.sh
} 

cleanMessage(){
    message "
    Cannot clean rook and rancher so please run these manually: \n
    ssh $NODE_USER@$CLUSTER_MASTER \n
    sudo rm -rf /var/lib/rook \n
    sudo rm -rf /var/lib/rancher
    "
}

uninstallFlux
#removek3s
cleanMessage

