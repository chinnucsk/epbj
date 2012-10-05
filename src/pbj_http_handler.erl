-module(pbj_http_handler).

-include("pbj_pb.hrl").

-export([
    init/3, handle/2, terminate/2,
    websocket_init/3, websocket_handle/3,
    websocket_info/3, websocket_terminate/3
  ]).

-include("pbj_pb.hrl").

-record(s, {

  }).

init({tcp, http}, Req0, _Opts) ->
  {Path, Req} = cowboy_req:path(Req0),
  case Path of
    <<"/ws/">> ->
      {upgrade, protocol, cowboy_websocket};
    Path ->
      {ok, Req, #s{}}
  end.

handle(Req0, State) ->
  Index = <<"<html><head></head><body>
  <script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js\"></script>
  <script type=\"text/javascript\">
  var ws = new WebSocket(\"ws://localhost:8080/ws/\");
  ws.onopen = function() {
    ws.send(JSON.stringify({
      sandwichRequest: {
        count: 4
      }
    }));
  };
  ws.onmessage = function(e) {
    var message = JSON.parse(e.data);
    console.log(\"Message\", message);
  };
  </script>
  </body></html>">>,
  {ok, Req} = cowboy_req:reply(200, [], Index, Req0),
  {ok, Req, State}.

terminate(_Req, _State) ->
  ok.

websocket_init(_TransportName, Req, _Opts) ->
  {ok, Req, #s{
    }}.

websocket_handle({text, JSON}, Req, State) ->
  #sandwich_request{
    count = Count
  } = pbj_pb:from_props(jsx:decode(JSON)),
  PBJ = #sandwich{
    bread = 'WHOLEMEAL',
    ingredients = [
      #peanut_butter{style = 'COARSE'},
      #jelly{flavor = 'STRAWBERRY'}
    ]
  },
  lists:foreach(
    fun(_) ->
        self() ! {send, PBJ}
    end,
    lists:seq(1, Count)
  ),
  {ok, Req, State}.

websocket_info({send, Message}, Req, State) ->
  {reply, {text, json(Message)}, Req, State};
websocket_info(_Info, Req, State) ->
  {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
  ok.

json(Message) ->
  jsx:encode(pbj_pb:json_ready(Message, true)).
