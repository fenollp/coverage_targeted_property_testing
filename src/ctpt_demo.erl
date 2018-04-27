-module(ctpt_demo).

-export([f/1]).

-include("ctpt.hrl").

-spec f(integer()) -> boolean().
f(N) when is_integer(N) ->
    case N of
        _ when N =:= ?SOME_VALUE -> false;
        _ -> true
    end.
