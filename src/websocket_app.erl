%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(websocket_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.
start(_Type, _Args) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/websocket", ws_handler, []},
      {"/js/[...]", cowboy_static, [
        {directory, {priv_dir, websocket, [<<"js">>]}},
        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
      ]},
      {"/", cowboy_static, [
        {directory, {priv_dir, websocket, [<<"">>]}},
        {file, <<"index.html">>},
        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
      ]}
    ]}
  ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]),
  websocket_sup:start_link().

stop(_State) ->
  ok.
