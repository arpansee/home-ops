#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

need() {
    if ! command -v "$1" &> /dev/null
then
    echo "$1" could not be found""
    exit
fi
}

message "Checking for dependencies"

need "kubectl"
need "helm"
need "flux"
need "openssl"
need "task"

message "Loading environment variables"
 . "$REPO_ROOT"/setup/.env

installFlux() {
  message "Bootstrapping Flux"
  flux check --pre > /dev/null
  FLUX_PRE=$?
  if [ $FLUX_PRE != 0 ]; then
    echo -e "flux prereqs not met:\n"
    flux check --pre
    exit 1
  fi
  if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is not set! Check $REPO_ROOT/setup/.env"
    exit 1
  fi
  flux bootstrap github \
    --owner="$GITHUB_USER" \
    --repository="$REPO" \
    --branch=main \
    --personal \
    --network-policy=false \
    --path=./k8s/cluster \
    --components-extra=image-reflector-controller,image-automation-controller

  FLUX_INSTALLED=$?
  if [ $FLUX_INSTALLED != 0 ]; then
    echo -e "flux did not install correctly, aborting!"
    exit 1
  fi
}

installFlux

message "all done!"
kubectl get nodes -o=wide

