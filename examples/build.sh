#!/bin/bash
pushd logs; alr build ; popd
pushd print; alr build ; popd
pushd dump; alr build; popd
