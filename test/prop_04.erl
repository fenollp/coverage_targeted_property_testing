%% -*- coding: utf-8 -*-
-module(prop_04).

-include_lib("proper/include/proper.hrl").

prop_04() ->
    ?FORALL_TARGETED(L, string()
                    ,begin
                         ok = cover_begin(),
                         Result = ctpt_demo2:f(L),
                         {ok,_Percentage,_Covered,_NotCovered} = cover_end(),

                         io:format(user, "~p/~p ~s%\n", [_Covered,_Covered+_NotCovered,float_to_list(_Percentage,[{decimals,2},compact])]),
                         %% ?MAXIMIZE(_Percentage),
                         %% ?MAXIMIZE(_Covered),
                         %% Note: using number of lines covered instead of coverage% is consistently better in empirical tests
                         %%   Maybe the search strategy sees more reward in an incr unbounded than whatever progress can be made within 0..1
                         %% Turns out trying to reward more doesn't work (here): 2* or 3* does not ever find 105*_!
                         ?MAXIMIZE(1 * _Covered),
                         Result
                     end
                    ).

cover_begin() ->
    %% cover:compile_beam_directory("ebin")
    {ok,_Pid} = cover:start(),
    {ok,_Mod} = cover:compile("src/ctpt_demo2.erl"),
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


%%% LibFuzzer finds this though
%% #![no_main]
%% #[macro_use] extern crate libfuzzer_sys;
%% // cargo fuzz run fuzz_target_1
%% fuzz_target!(|data: &[u8]| {
%%     if let Ok(s) = std::str::from_utf8(data) {
%%         if s.len() > 0 && s.get(0..1) == Some("H") {
%%             if s.len() > 1 && s.get(1..2) == Some("i") {
%%                 if s.len() > 2 && s.get(2..3) == Some("!") {
%%                     panic!();
%%                 }
%%             }
%%         }
%%     }
%% });
