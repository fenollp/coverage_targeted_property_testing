# [coverage_targeted_property_testing](https://github.com/fenollp/coverage_targeted_property_testing) [![CircleCI](https://circleci.com/gh/fenollp/coverage_targeted_property_testing/tree/master.svg?style=svg)](https://circleci.com/gh/fenollp/coverage_targeted_property_testing/tree/master)

Use code coverage as a "utility value" for PropEr (quickcheck) to maximize.

Branchy code is notoriously hard for Quickcheck to test.
Fuzzing or concolic testing tools such as [afl](http://lcamtuf.coredump.cx/afl/) or [KLEE](https://klee.github.io) are better than Quickcheck at executing a maximum of code branches.

An example function with a hard-to-reach branch:
```erlang
-spec f(integer()) -> boolean().
f(42) -> false;  %% Of all possible Erlang values, only 42 and 42.0 match here
f(_) -> true.
```

This demo repo shows that [PropEr](https://hex.pm/packages/proper)'s search strategies can use coverage information to actively try and reach more branches than before.


## [prop_01_basic](./test/prop_01_basic.erl)

This file implements a straightforward Quickcheck property, using the common tools of most QuickCheck implementations.

```erlang
prop_01() ->
    ?FORALL(N, integer(), ctpt_demo:f(N)).
```

In most runs, this property passes. PropEr is just guessing in a vacuum.


## [prop_02_informed](./test/prop_02_informed.erl)

Same property as above except the explorable space is much smaller than all of `integer()`.

```erlang
expected_edge_cases() ->
    oneof([...some integers..., 42, ...]).

prop_02() ->
    ?FORALL(N, expected_edge_cases(), ctpt_demo:f(N)).
```

Since `42` is generatable by `expected_edge_cases()` this property always fails.


## [prop_03_coverage_targeted](./test/prop_03_coverage_targeted)

Now, let's use [*Targeted Property-Based Testing*](http://proper.softlab.ntua.gr/papers/issta2017.pdf): let's collect coverage data on the code we run then tell our search startegy about it. This should guide example generation towards hitting more branches of our code.

```erlang
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
```

Indeed, now the property almost always fails!

## Future work

* Have this kind of tool be available upstream. [See related ticket in PropEr](https://github.com/manopapad/proper/issues/159)
* More testing with branchier code
* More testing with search strategies other than `simulated_annealing`
    * `hill_climbing` for instance, since it's alreay implemented
    * Maybe `afl`'s search strateg{y,ies} can be ported to Erlang?
    * Genetic algorithms could help and they should be a great fit for Erlang but are notoriously hard to tweak
* Measuring coverage in addition to keeping a counterexample database has interesting applications:
    * Clustering counterexamples on the parts of the code they test, the bugs they find
    * Minimizing such a database to only keep the relevant regression tests
