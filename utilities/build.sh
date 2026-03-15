#!/bin/bash

pushd gitrev; alr build; popd
./bin/gitrev -r 0.2.0 -eSHA=$GITHUB_SHA,RUN=$GITHUB_RUN_ID:$GITHUB_RUN_NUMBER -o revisions .
pushd codemd; alr build; popd
