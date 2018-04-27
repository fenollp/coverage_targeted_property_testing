-module(ctpt_demo).

-export([f/1]).

-include("ctpt.hrl").

-define(HERE, io:format(user, " line:~p ", [?LINE])).

-spec f(integer()) -> boolean().
f(N) when is_integer(N) ->
    case N of
        _ when N =:= ?SOME_VALUE -> ?HERE, false;
        _ when N < ?SOME_VALUE/2 ->
            case N of
                _ when N =:= ?SOME_VALUE div 2 -> ?HERE, false;
                _ when N < ?SOME_VALUE/4 ->
                    case N of
                        _ when N =:= ?SOME_VALUE div 4 -> ?HERE, false;
                        _ when N < ?SOME_VALUE/8 ->
                            case N of
                                _ when N > ?SOME_VALUE/8 -> ?HERE, false;
                                _ -> ?HERE, true
                            end;
                        _ -> ?HERE, true
                    end;
                _ -> ?HERE, true
            end;
        _ -> ?HERE, true
    end.
