-module(vg_controller).

-behaviour(gen_statem).

-export([start_link/0]).

-export([init/1,
         callback_mode/0,
         terminate/3]).

-export([initializing/3,
         ready/3]).

-include("vg_operator.hrl").

-record(data, {}).

start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, initializing, #data{}, [{next_event, internal, ensure_crd}]}.

callback_mode() ->
    state_functions.

initializing(internal, ensure_crd, Data) ->
    Crd = #{apiVersion => <<"apiextensions.k8s.io/v1beta1">>,
            kind => <<"CustomResourceDefinition">>,
            metadata =>
                #{name => <<"vonnegutclusters.vonnegutoperator.spacetimeinsight.com">>},
            spec =>
                #{group => <<"vonnegutoperator.spacetimeinsight.com">>,
                  version => <<"v1alpha1">>,
                  names =>
                      #{kind => <<"VonnegutCluster">>,
                        plural => <<"vonnegutclusters">>},
                  scope => <<"Namespaced">>}},
    case vg_kube_utils:create_custom_resource_definition(Crd) of
        ok ->
            {next_state, ready, Data};
        error ->
            %% log and retry after a timeout
            keep_state_and_data
    end;
initializing(EventType, EventContent, Data) ->
    handle_event(EventType, EventContent, Data).

ready(EventType, EventContent, Data) ->
    handle_event(EventType, EventContent, Data).

terminate(_Reason, _State, _Data) ->
    ok.

%%

handle_event(_, _, Data) ->
    %% Ignore all other events
    {keep_state,Data}.

