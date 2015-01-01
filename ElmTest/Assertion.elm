module ElmTest.Assertion where

{-| The basic component of a test case, an assertion.

# Assert
@docs assertT, assert, assertEqual, assertNotEqual

-}

import List

type alias Thunk a = () -> a

type Assertion = AssertTrue     (Thunk Bool)
               | AssertFalse    (Thunk Bool)
               | AssertEqual    (Thunk Bool) (Thunk String) (Thunk String)
               | AssertNotEqual (Thunk Bool) (Thunk String) (Thunk String)

{-| Basic function to create an Assert True assertion. Delays execution until tests are run. -}
assert : Thunk Bool -> Assertion
assert = AssertTrue

{-| Basic function to create an Assert Equals assertion, the expected value goes on the left. -}
assertEqual : Thunk a -> Thunk a -> Assertion
assertEqual a b = AssertEqual (\_ -> a () == b ()) (\_ -> toString <| a ()) (\_ -> toString <| b ())

{-| Given a list of values and another list of expected values,
generate a list of Assert Equal assertions. -}
assertionList : List (Thunk a) -> List (Thunk a) -> List Assertion
assertionList xs ys = List.map2 assertEqual xs ys

{-| Basic function to create an Assert Not Equals assertion. -}
assertNotEqual : Thunk a -> Thunk a -> Assertion
assertNotEqual a b = AssertNotEqual (\_ -> a () /= b ()) (\_ -> toString <| a ()) (\_ -> toString <| b ())
