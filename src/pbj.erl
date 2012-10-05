-module(pbj).

-export([
    start/0
  ]).

start() ->
  application:start(protobufs),
  application:start(ranch),
  application:start(cowboy),
  application:start(pbj).
