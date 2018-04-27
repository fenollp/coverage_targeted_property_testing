-module(ctpt_demo2).

-export([f/1]).

-define(HERE, io:format(user, " line:~p ", [?LINE])).

-spec f(string()) -> boolean().
f(L) when is_list(L) ->
    case L of
        "H"++_ ->
            case L of
                "Hi"++_ ->
                    case L of
                        "Hi!"++_ -> ?HERE, false;
                        _ -> ?HERE, true
                    end;
                _ -> ?HERE, true
            end;
        _ -> ?HERE, true
    end.
