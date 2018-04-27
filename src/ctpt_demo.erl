-module(ctpt_demo).

-export([f/1]).

-include("ctpt.hrl").

-define(HERE, io:format(user, " line:~p ", [?LINE])).

-spec f(integer()) -> boolean().
f(N) when is_integer(N) ->
    case N of
        0 -> ?HERE, true;
        _ when N rem 3 =:= 0 ->
            case N of
                _ when N rem 5 =:= 0 ->
                    case N of
                        _ when N rem 7 =:= 0 -> ?HERE, false;
                        _ -> ?HERE, true
                    end;
                _ -> ?HERE, true
            end;
        _ -> ?HERE, true
    end.
