#!/bin/bash
set -xe

## Build fuzzing targets
## go-fuzz doesn't support modules for now, so ensure we do everything
## in the old style GOPATH way
export GO111MODULE="off"

## Install go-fuzz
go get -u github.com/dvyukov/go-fuzz/go-fuzz github.com/dvyukov/go-fuzz/go-fuzz-build
# download dependencies into ${GOPATH}
# -d : only download (don't install)f
# -v : verbose
# -u : use the latest version
# will be different if you use vendoring or a dependency manager
# like godep
go get -d -v -u ./...

ls -l $GOPATH/bin
go-fuzz-build -libfuzzer -o parse_json_fuzz.a .
clang -fsanitize=fuzzer parse_json_fuzz.a  -o parse_json_fuzz

## Install fuzzit latest version:
wget -O fuzzit https://github.com/fuzzitdev/fuzzit/releases/latest/download/fuzzit_Linux_x86_64
chmod a+x fuzzit

## upload fuzz target for long fuzz testing on fuzzit.dev server or run locally for regression
./fuzzit create target --seed github.com/WilliamHeaven/jsonparser/tree/fuzztest/fuzztest/corpus --skip-if-exists jsonparser1 
./fuzzit create job --type ${1} williamheaven/jsonparser1 parse_json_fuzz 
