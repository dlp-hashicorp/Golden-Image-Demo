#!/usr/bin/env bash

set -e

### Setting HCP Packer auth ###
export HCP_CLIENT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export HCP_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export HCP_PACKER_BUILD_FINGERPRINT="$(date +%s)"

### Build Packer Image  ###
echo "Building an ACME Image..."

### Initialize Hashicorp Packer and required plugins ###
echo "Initializing Hashicorp Packer and required plugins..."

packer init "$1"/.

### Start the Build ###
echo "Starting the build..."

packer build -on-error=ask -force \
-var-file="$1/az.pkrvars.hcl" \
$1

### Build Complete ###
echo "Build Complete."

