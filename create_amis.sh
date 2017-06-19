#!/bin/bash

curpath=$(dirname $0)

die () {
    echo; echo -e "ERROR: $1"; echo; cd $curdir; exit 1
}

install_packer () {
    mkdir -p $curpath/.bin
    curl -sSL https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip -o $curpath/.bin/packer.zip
    unzip -qq $curpath/.bin/packer.zip -d $curpath/.bin
    rm -f $curpath/.bin/packer.zip
}

packer_tool="$(which packer)"
if [ -z "$packer_tool" ]; then
    echo "Installing packer locally to $curpath/.bin dir"
    install_packer
    packer_tool="$curpath/.bin/packer"
fi

$packer_tool build k8s-1.6-gpu-xenial.json
