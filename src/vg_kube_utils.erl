-module(vg_kube_utils).

-export([create_custom_resource_definition/1]).

create_custom_resource_definition(Crd) ->
    case kuberl_apiextensions_v1beta1_api:create_custom_resource_definition(ctx:background(), Crd) of
        {ok, _Result, _RespInfo} ->
            ok;
        {error, _Result, _RespInfo} ->
            error
    end.
