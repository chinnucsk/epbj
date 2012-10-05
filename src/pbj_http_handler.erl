-module(pbj_http_handler).

-include("pbj_pb.hrl").

-export([
    init/3, handle/2, terminate/2,
    websocket_init/3, websocket_handle/3,
    websocket_info/3, websocket_terminate/3
  ]).


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
    console.log(\"opened\");
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
  PBJ = #sandwich{
    bread = 'WHOLEMEAL',
    ingredients = [
      #peanut_butter{style = 'COARSE'},
      #jelly{flavor = 'STRAWBERRY'}
    ]
  },
  self() ! {send, PBJ},
  {ok, Req, #s{
    }}.

websocket_handle({text, _JSON}, Req, State) ->
  {ok, Req, State}.

websocket_info({send, Message}, Req, State) ->
  {reply, {text, json(Message)}, Req, State};
websocket_info(_Info, Req, State) ->
  {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
  ok.

json(Message) ->
  jsx:encode(pbj_pb:json_ready(Message)).
