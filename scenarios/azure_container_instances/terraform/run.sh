#!/bin/bash

shopt -s expand_aliases
alias terra=terraform

# check if terraform is installed
if ! command -v terraform &> /dev/null
then
    echo "Terraform could not be found"
    exit 1
fi

# check if secrets exist
if test -f ./secrets.sh; then
    source secrets.sh
fi

terra plan
terra apply
