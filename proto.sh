#!/bin/sh

ERL_LIBS=deps/ deps/protobuffs/bin/protoc-erl include/pbj.proto \
  && mv pbj_pb.erl src \
  && mv pbj_pb.hrl include
