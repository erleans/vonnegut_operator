%%%-------------------------------------------------------------------
%% @doc vonnegut_operator public API
%% @end
%%%-------------------------------------------------------------------

-module(vonnegut_operator_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    vonnegut_operator_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================