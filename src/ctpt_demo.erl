-module(ctpt_demo).

-export([f/1]).

-spec f(integer()) -> boolean().
f(N) when is_integer(N) ->
    case N of
        _ when N =:= 42 -> false;
        _ -> true
    end.
