-module(pbj_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  pbj_http:start(),
  pbj_sup:start_link().

stop(_State) ->
  ok.
