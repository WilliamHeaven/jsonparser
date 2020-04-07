#!/bin/bash
set -xe

# Validate arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <fuzz-type>"
    exit 1
fi

# Configure
NAME=jsonparser
TYPE=local-regression
FUZZIT_VERSION=2.4.61
GO_FUZZ_VERSION=1810d380ab9c2786af00db592f86d83063216ed0

# Setup
export GO111MODULE=on
go get -u -v \
    github.com/dvyukov/go-fuzz/go-fuzz@$GO_FUZZ_VERSION \
    github.com/dvyukov/go-fuzz/go-fuzz-build@$GO_FUZZ_VERSION
    
export GOPATH=$PWD/gopath
export GO111MODULE=off
if [[ ! -f fuzzit || ! `./fuzzit --version` =~ $FUZZIT_VERSION$ ]]; then
    wget -q -O fuzzit https://github.com/fuzzitdev/fuzzit/releases/download/v$FUZZIT_VERSION/fuzzit_Linux_x86_64
    chmod a+x fuzzit
fi
./fuzzit --version

# Fuzz

FUNC=Fuzz
TARGET=$2
go-fuzz-build -libfuzzer -func $FUNC -o fuzzer.a .
clang -fsanitize=fuzzer fuzzer.a -o fuzzer
./fuzzit create job --type $TYPE $NAME/$TARGET fuzzer
