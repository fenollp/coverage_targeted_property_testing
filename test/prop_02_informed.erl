%% -*- coding: utf-8 -*-
-module(prop_02_informed).

-include_lib("proper/include/proper.hrl").

%% An informed tester will try/guess some expected edge cases.

expected_edge_cases() ->
    oneof([-43,-42, -21, -3,-2-1, 0, 1,2,3, 21, 42,43]).

prop_informed() ->
    ?FORALL(N, expected_edge_cases(), ctpt_demo:f(N)).
