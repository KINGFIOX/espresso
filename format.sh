#!/bin/bash

clang-format -i espresso/*.{h,c}
shfmt -i 4 -w format.sh
prettier --write .github/workflows/*
