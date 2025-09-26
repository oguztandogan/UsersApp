#!/bin/bash

# SwiftLint Build Phase Script
# Add this script to Xcode Build Phases -> New Run Script Phase

export PATH="$PATH:/opt/homebrew/bin"

if which swiftlint > /dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
