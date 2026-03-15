#!/bin/bash

pushd gitrev; alr build; popd
./bin/gitrev -r 0.2.0 -o revisions .
pushd codemd; alr build; popd
