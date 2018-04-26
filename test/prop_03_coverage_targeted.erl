%% -*- coding: utf-8 -*-
-module(prop_03_coverage_targeted).

-include_lib("proper/include/proper.hrl").

%% Search for maximized code coverage using simulated annealing.

prop_03() ->
    ?FORALL_TARGETED(N, integer()
                    ,begin
                         ok = cover_begin(),
                         Result = ctpt_demo:f(N),
                         {ok,Coverage} = cover_end(),
                         ?MAXIMIZE(Coverage),
                         Result
                     end
                    ).

cover_begin() ->
    %% cover:compile_beam_directory("ebin")
    {ok,_Pid} = cover:start(),
    {ok,_Mod} = cover:compile("src/ctpt_demo.erl"),
    [_|_] = cover:modules(),
    ok.

cover_end() ->
    {result,Ok,_Fail=[]} = cover:analyse(coverage, line),
    ok = cover:stop(),
    {Covs,NotCovs} = lists:unzip([{Cov,NotCov} || {_ModLine, {Cov,NotCov}} <- Ok]),
    Coverage =
        case lists:sum(NotCovs) of
            0 -> 100.0;
            NotCovered ->
                Covered = lists:sum(Covs),
                trunc(100 * (Covered / (Covered + NotCovered)))
        end,
    {ok, Coverage}.
