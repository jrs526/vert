#!/bin/sh
GOOS=js GOARCH=wasm go test -v -exec="$GOPATH/bin/wasmbrowsertest"