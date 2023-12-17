#!/bin/bash
dart pub global activate protoc_plugin
export PATH="$PATH":"$HOME/.pub-cache/bin"
dart run submodule/temperature_proto/install_helper.dart