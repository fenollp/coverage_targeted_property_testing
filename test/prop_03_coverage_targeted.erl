%% -*- coding: utf-8 -*-
-module(prop_03_coverage_targeted).

-include_lib("proper/include/proper.hrl").

%% Search for maximized code coverage using simulated annealing.

prop_03() ->
    ?FORALL_TARGETED(N, integer()
                    ,begin
                         ok = cover_begin(),
                         Result = ctpt_demo:f(N),
                         {ok,_Percentage,_Covered,_NotCovered} = cover_end(),

                         io:format(user, "~p/~p ~s%\n", [_Covered,_Covered+_NotCovered,float_to_list(_Percentage,[{decimals,2},compact])]),
                         ?MAXIMIZE(_Covered),
                         %% ?MAXIMIZE(_Percentage),
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
    {Covered,NotCovered} = {lists:sum(Covs), lists:sum(NotCovs)},
    Coverage = 100.0 * case NotCovered of
                           0 -> 1;
                           NotCovered -> Covered / (Covered + NotCovered)
                       end,
    {ok, Coverage, Covered, NotCovered}.
