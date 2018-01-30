%%%-------------------------------------------------------------------
%% @doc vonnegut_operator top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(vonnegut_operator_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Children = [#{id => vg_watch_crd,
                  start => {vg_watch_crd, start_link, []}},
                #{id => vg_controller,
                  start => {vg_controller, start_link, []}}],

    {ok, {{one_for_all, 0, 1}, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
