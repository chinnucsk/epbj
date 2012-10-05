#!/bin/sh
erl \
    -pa ebin deps/*/ebin \
    -pbj port 8080 \
    $@ \
    -s pbj
