#!/bin/bash
set -xe

## Build fuzzing targets
## go-fuzz doesn't support modules for now, so ensure we do everything
## in the old style GOPATH way
export GO111MODULE="on"

## Install go-fuzz
go get -u github.com/dvyukov/go-fuzz/go-fuzz github.com/dvyukov/go-fuzz/go-fuzz-build

# download dependencies into ${GOPATH}
# -d : only download (don't install)f
# -v : verbose
# -u : use the latest version
# will be different if you use vendoring or a dependency manager
# like godep
go get -d -v -u ./...

go-fuzz-build -libfuzzer -o parse_json_fuzz.a .
clang -fsanitize=fuzzer parse_json_fuzz.a 

## Install fuzzit latest version:
wget -O fuzzit https://github.com/fuzzitdev/fuzzit/releases/latest/download/fuzzit_Linux_x86_64
chmod a+x fuzzit

## upload fuzz target for long fuzz testing on fuzzit.dev server or run locally for regression
export FUZZIT_API_KEY=339773068c2d0656b6dfbd3894aca9dd67cd7077a1974def6123fb4d62114d00313ffb79c42302c804e6793e92fdb6d4f
./fuzzit create job --type ${1} fuzzitdev/fuzztest/parse_json_fuzz parse_json_fuzz
