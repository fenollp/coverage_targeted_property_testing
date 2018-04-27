-module(ctpt_demo2).

-export([f/1]).

-define(HERE, io:format(user, " line:~p ", [?LINE])).

-spec f(string()) -> boolean().
f(L) when is_list(L) ->
    Len = length(L),
    case Len > 0 andalso lists:nth(1,L) of
        "H" ->
            case Len > 1 andalso lists:nth(2,L) of
                "i" ->
                    case Len > 2 andalso lists:nth(3,L) of
                        "!" -> ?HERE, false;
                        _ -> ?HERE, true
                    end;
                _ -> ?HERE, true
            end;
        _ -> ?HERE, true
    end.
