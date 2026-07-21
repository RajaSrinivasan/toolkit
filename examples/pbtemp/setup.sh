#!/bin/bash

export NANOPBDIR=`realpath ../../nanopb`
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install --upgrade protobuf grpcio-tools
