#!/bin/bash

pushd gitrev; alr build; popd
./bin/gitrev -r 0.2.0 -eSHA=$GITHUB_SHA,RUN=$GITHUB_RUN_ID:$GITHUB_RUN_NUMBER -o revisions .
cat revisions.ads
pushd codemd; alr build; popd
pushd dump ; alr build; popd
pushd gitrev; alr clean; alr build; popd