-module(vg_watch_crd).

-behaviour(kuberl_watch).

-export([start_link/0,
         init/1,
         handle_event/3,
         terminate/2]).

-include("vg_operator.hrl").

start_link() ->
    kuberl_watch:start_link(?MODULE, kuberl_custom_objects_api, list_cluster_custom_object,
                            [ctx:background(), ?GROUP, ?VERSION, ?PLURAL], #{}, []).

init([]) ->
    {ok, []}.

handle_event(added, A=#{apiVersion := ApiVersion,
                        kind := ?KIND,
                        metadata := #{name := Name,
                                      uid := Uid},
                        spec := Spec}, State) ->
    lager:info("Added : ~p", [A]),
    OwnerRef = #{apiVersion => ApiVersion,
                 blockOwnerDeletion => true,
                 controller => true,
                 kind => ?KIND,
                 name => Name,
                 uid => Uid},
    Replicas = maps:get(replicas, Spec, 1),
    StatefulSet = vg_controller:new(Name, OwnerRef, Replicas),

    case kuberl_apps_v1_api:create_namespaced_stateful_set(ctx:background(), <<"default">>, StatefulSet) of
        {error, Error, RespInfo} ->
            lager:info("R ~p ~p", [Error, RespInfo]);
        {ok, Result, RespInfo} ->
            lager:info("OK ~p ~p", [Result, RespInfo])
    end,
    {ok, State};
handle_event(deleted, A=#{metadata := #{name := _Name}}, State) ->
    lager:info("Deleted : ~p", [A]),
    {ok, State};
handle_event(modified, #{metadata := #{name := Name}}, State) ->
    lager:info("Modified : ~p", [Name]),
    {ok, State};
handle_event(error, #{message := Message}, State) ->
    lager:info("Error : ~p", [Message]),
    {ok, State}.

terminate(_Reason, _State) ->
    ok.
