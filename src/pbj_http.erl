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
  R = cowboy:start_http(pbj_http, 100, [{port, Port}],
    [{dispatch, Dispatch}]
  ),
  io:format(
    "Now point your browser at http://localhost:~p/"
    " and have a look at the javascript console.~n", [Port]),
  R.
