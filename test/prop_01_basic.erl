%% -*- coding: utf-8 -*-
-module(prop_01_basic).

-include_lib("proper/include/proper.hrl").

%% Too hard for a simple property like this one to find failure!

prop_basic() ->
    ?FORALL(N, integer(), ctpt_demo:f(N)).
