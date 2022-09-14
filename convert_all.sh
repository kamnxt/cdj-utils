#!/bin/bash

find src -type f -iname \*.flac | parallel -j8 -q ./convert_file.sh {}
