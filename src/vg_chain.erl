-module(vg_chain).

-export([new_chain/3]).

new_chain(Name, OwnerRef, Replicas) ->
    StatefulSetMetadata = #{name => Name,
                            ownerReferences => [OwnerRef]},
    #{apiVersion => <<"apps/v1">>,
      kind => <<"StatefulSet">>,
      metadata => StatefulSetMetadata,
      spec => #{replicas => Replicas,
                serviceName => Name,
                selector => #{matchLabels => #{<<"app">> => <<"vonnegut">>}},
                template => #{metadata => #{labels => #{<<"app">> => <<"vonnegut">>}},
                              spec => #{containers => [#{name => <<"busybox">>}]}}}}.
