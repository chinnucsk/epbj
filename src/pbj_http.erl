-module(pbj_http).
-export([
    start/0
  ]).

start() ->
  Dispatch = [
    {'_', [
        {'_', pbj_http_handler, []}
      ]}
  ],
  {ok, Port} = application:get_env(pbj, port),
  cowboy:start_http(pbj_http, 100, [{port, Port}],
    [{dispatch, Dispatch}]
  ).
